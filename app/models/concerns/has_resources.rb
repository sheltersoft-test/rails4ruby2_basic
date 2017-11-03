module HasResources
  extend ActiveSupport::Concern

  included do
    has_many :resources, :as => :resource_holder, :dependent => :destroy do
    def [](type_spec)
      type, spec = type_spec.to_s.split '::'
      conditions = {:'resource_types.name' =>  type}
      conditions[:'resource_specs.name'] = spec if spec.present?
      includes(:resource_type, :resource_spec).where(conditions).first
    end

    def with_type(type_spec)
      type, spec = type_spec.to_s.split '::'
      conditions = { :'resource_types.name' =>  type }
      conditions[:'resource_specs.name'] = spec if spec.present?
      includes(:resource_type, :resource_spec).where(conditions)
    end
  end
  accepts_nested_attributes_for :resources, :allow_destroy => true
  end
end
