# -*- encoding : utf-8 -*-
module Utils
  module Views
    module NestedSet
      extend CollectiveIdea::Acts::NestedSet::Helper

      def self.nested_select(klass)
        nested_set_options(klass) { |i| "#{'–' * i.depth} #{i.title}" } if klass.table_exists?
      end

      def self.get_all(klass)
        klass.all if klass.table_exists?
      end

      def ans_controls(node, options= {})
        opts= {
            :class_name => nil, # class of nested elements
            :id_field => 'id', # id field name, id by default
            :first => false, # first element flag
            :last => false, # last element flag
            :has_children => false # has children?
        }.merge!(options)

        render :partial => "#{opts[:path]}/controls", :locals => {:node => node, :opts => opts}
      end

      def create_root_element_link(class_name, options={})
        opts = {:top_root => false}.merge!(options)
        render :partial => "#{opts[:path]}/create_root", :locals => {:class_name => class_name, :opts => opts}
      end

      def ans_tree(tree, options= {})
        result = ''
        opts= {
            :node => nil, # node
            :admin => false, # render admin tree?
            :root => false, # is it root node?
            :id_field => 'id', # id field name, id by default
            :class_name => nil, # class of nested elements
            :path => 'ans', # default view partials path
            :first => false, # first element flag
            :last => false, # last element flag
            :level => 0, # recursion level
            :clean => true, # delete element from tree after rendering?
            :main => nil
        }.merge!(options)

        node = opts[:node]
        root = opts[:root]
        # must be string
        opts[:id_field]= opts[:id_field].to_s
        # find class name
        opts[:class_name]= opts[:class_name] ? opts[:class_name].to_s.downcase : tree.first.class.to_s.downcase

        return create_root_element_link(opts[:class_name], opts) if tree.empty?

        unless node
          roots = tree.select { |elem| elem.parent_id == opts[:main].id }
          roots_first_id = roots.empty? ? nil : roots.first.id
          roots_last_id = roots.empty? ? nil : roots.last.id

          # render roots
          roots.each do |root|
            is_first= (root.id == roots_first_id)
            is_last= (root.id == roots_last_id)
            _opts = opts.merge({:node => root, :root => true, :level => opts[:level].next, :first => is_first, :last => is_last})
            result<< ans_tree(tree, _opts)
          end
        else
          res = ''
          controls = ''
          children_res = ''

          # select children
          children = tree.select { |elem| elem.parent_id == node.id }
          opts.merge!({:has_children => children.blank?})
          # admin controls
          if opts[:admin]
            c = ans_controls(node, opts)
            controls = content_tag(:span, c, :class=>:controls)
          end
          # find id of first and last node
          child_first_id = children.empty? ? nil : children.first.id
          child_last_id = children.empty? ? nil : children.last.id
          # render children
          children.each do |elem|
            is_first = (elem.id == child_first_id)
            is_last = (elem.id == child_last_id)
            _opts = opts.merge({:node => elem, :root => false, :level => opts[:level].next, :first => is_first, :last => is_last})
            children_res << ans_tree(tree, _opts)
          end
          # build views
          children_res = children_res.blank? ? '' : render(:partial => "#{opts[:path]}/nested_set", :locals => {:parent => node, :children => children_res})
          link = render(:partial => "#{opts[:path]}/link", :locals => {:node => node, :opts => opts, :root => root, :controls => controls})
          res = render(:partial => "#{opts[:path]}/nested_set_item", :locals => {:node => node, :link => link, :children => children_res})
          result << res
        end
        # decorate with 'create root' links
        if opts[:level].zero?
          result = raw(result)
          result << create_root_element_link(opts[:class_name], opts)
        end
        result
      end
    end

  end
end
