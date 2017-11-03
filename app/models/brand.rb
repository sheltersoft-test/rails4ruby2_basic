class Brand < ActiveRecord::Base

  has_many :users, inverse_of: :brand do
    def with_role(role)
      where({ :'users.role' => User.roles[role] }) if role.present?
    end

    def with_roles(roles)
      where({ :'users.role' => roles.map{|role| User.roles[role]} }) if roles.present?
    end
  end

  has_many :resources, :as => :resource_holder do
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

  has_many :language_skills, inverse_of: :brand
  has_many :feedbacks, inverse_of: :brand
  has_many :settings, inverse_of: :brand
  
  CUSTOM_DOMAIN_WITH_SSL = 'ssl'
  CUSTOM_DOMAIN_WITHOUT_SSL = 'no_ssl'

  validates :name, :presence => true, uniqueness: true, :length => {:maximum => 100}
  validates :prefix, :presence => true, uniqueness: true, :length => {:maximum => 4}, :format => {:with => CustomValidation.name_regex, :message => CustomValidation.bad_name_message}
  validates :description, :length => {:maximum => 2000, :allow_blank => true}
  validates :phone_number, :length => {:maximum => 50, :allow_blank => true}
  validates :email, :length => {:maximum => 50, :allow_blank => true}, :format=>{:with => CustomValidation.email_regex, :message => CustomValidation.bad_email_message, :allow_blank => true}

  has_attached_file :logo,
                    styles: lambda { |a| a.instance.styles_convert_options },
                    convert_options: { all: '-auto-orient' },
                    path: :brand_logo_path,
                    url: :brand_logo_url,
                    default_url: :brand_logog_default_url

  validates_attachment_content_type :logo, 
                                    :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]  

  def styles_convert_options    
    { :medium => ["160x120#"], :small => ["80x60>"] }
  end

  def hostname(options = {})
    ssl = options[:ssl]
    if custom_domain.present?
      if ssl
        if custom_domain_type == CUSTOM_DOMAIN_WITH_SSL
          return custom_domain
        else
          return "#{slug}.#{Settings.system.domain}"
        end
      else
        return custom_domain
      end
    else
      return "#{slug}.#{Settings.system.domain}"
    end
  end  

  private

  def brand_logo_path
    Settings.content.resource.brand_logo_path
  end

  def brand_logo_url
    Settings.content.resource.brand_logo_url
  end

  def brand_logog_default_url
    Settings.content.resource.brand_logog_default_url
  end
end
