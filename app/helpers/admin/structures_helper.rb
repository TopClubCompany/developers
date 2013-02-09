# -*- encoding : utf-8 -*-
module Admin::StructuresHelper
  def edit_structure_record_path(structure)
    case structure.structure_type
      when StructureType.static_page
        if structure.static_page
          edit_admin_structure_static_page_path(:structure_id => structure.id)
        else
          new_admin_structure_static_page_path(:structure_id => structure.id)
        end
      when StructureType.posts then '#' #admin_structure_posts_path(:structure_id => structure.id)
      when StructureType.main then '#'
      when StructureType.redirect then structure.slug
      when StructureType.group then '#'
      else
        '#'
    end
  end

  def structure_select(kind=nil)
    scope = kind ? Structure.with_kind(kind) : Structure
    scoped_nested_set_options(scope) { |i| "#{'–' * i.depth} #{i.title}"}
  end

  def scoped_nested_set_options(scope, mover = nil)
    items = scope.roots
    result = []
    items.each do |root|
      result += root.self_and_descendants.merge(scope).map do |i|
        if mover.nil? || mover.new_record? || mover.move_possible?(i)
          [yield(i), i.id]
        end
      end.compact
    end
    result
  end

  def select_nested_set(scope)
    scoped_nested_set_options(scope) { |i| "#{'–' * i.depth} #{i.title}" }
  end

end
