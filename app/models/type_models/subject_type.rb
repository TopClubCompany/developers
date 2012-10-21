class SubjectType
  include EnumField::DefineEnum
  attr_reader :model, :options, :code, :member_actions, :collection_actions, :assocs

  @@data = YAML.load_file(Rails.root.join('config', 'cancan_subjects.yml'))
  @@default_options = {
      :member_actions => [:read, :update, :delete],
      :collection_actions => [:read, :create, :update, :delete],
      :assocs => []
  }

  def initialize(code)
    @code = code.to_sym
    @options = @@data[@code]
    @model = options[:model].constantize
    @member_actions = options[:member_actions] || @@default_options[:member_actions]
    @collection_actions = options[:collection_actions] || @@default_options[:collection_actions]
    @assocs = options[:assocs] || @@default_options[:assocs]
  end

  define_enum do |builder|
    @@data.each_key do |k|
      builder.member k, :object => new(k.to_s)
    end
  end

  def self.per_collection
    all.find_all { |s| s.options[:collection] }
  end

  def self.per_resource
    all.find_all { |s| s.options[:resource] }
  end

  def resources
    @model.all
  end

  def full_member_actions
    scope = [:admin, :perms, :actions]
    member_actions.map { |a| {title: I18n.t(a, scope: scope), key: a} }
  end

  def full_assocs
    scope = [:admin, :perms, :assocs]
    assocs.map do |a|
      assoc_obj = model.reflect_on_association(a)
      raise "no reflection on #{model} for #{a}" unless assoc_obj
      {title: I18n.t(a, scope: scope), key: a, :klass => assoc_obj.klass.name}
    end
  end

  def full_collection_actions
    scope = [:admin, :perms, :actions]
    collection_actions.map { |a| {title: I18n.t(a, scope: scope), key: a} }
  end

  def for_form
    {}.tap do |h|
      h[:id] = id
      h[:title] = title
      h[:member_actions] = full_member_actions if options[:resource]
      h[:assocs] = full_assocs if options[:collection]
      h[:collection_actions] = full_collection_actions if options[:collection]
      h[:is_own] = options[:is_own]
      h[:is_visibility] = options[:is_visibility]
      h[:is_work] = is_work
      h[:klass] = @model.name
    end
  end

  def self.for_form
    all.map(&:for_form).to_json
  end

  def is_visibility
    options[:is_visibility]
  end

  def is_own
    options[:is_own]
  end

  def is_work
    !!options[:is_work]
  end

  def title
    I18n.translate!(@code, :scope => [:active, :perms])
  rescue I18n::MissingTranslationData
    @model.respond_to?(:model_name) ? @model.model_name.human : @model.titleize
  end

  def self.legal?(value)
    all_ids.include?(value)
  end

  def self.all_ids
    all.map(&:id)
  end

end