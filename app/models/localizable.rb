module Localizable
  extend ActiveSupport::Concern

  included do
    
    localizable_name = name.demodulize.underscore

    def self.localization_class
      public_send "#{name}Localization"
    end

    has_one :admin_localization, -> { where(language_code: Object.const_get(name).language_codes[I18n.locale.upcase]) }, class_name: "#{name}Localization"

    class_eval "

      has_many :#{localizable_name}_localizations,
               inverse_of: :#{localizable_name}, dependent: :destroy do

        def [](language_code)
          model = Object.const_get(name)
          find_by(language_code: model.language_codes[language_code.to_s.upcase])
        end

        def lang!(language_code, setter={})
          upsert(
            {language_code: language_code.to_s.upcase},
            setter
          )
        end

        def fallback
          find_by(language_code: I18n.locale.to_s.upcase) ||
            find_by(language_code: I18n.default_locale.to_s.upcase) ||
            first
        end

      end

      accepts_nested_attributes_for :#{localizable_name}_localizations, allow_destroy: true

      has_many :user_skills, :as => :skill, :dependent => :destroy
      has_many :users, :through => :user_skills

      scope :all_by_brand, -> (brand_id) { where(:brand_id => brand_id) }

      def localizations
        #{localizable_name}_localizations
      end
    "
  end

  def current_language_code
    @language_code || Settings.locale.default.language.to_s.upcase
  end

  def localize(language_code)
    return self if @language_code == language_code

    @localization =
      localizations[language_code] ||
      localizations[Settings.locale.default.language.to_s.upcase] ||
      localizations.first

    return nil unless @localization

    @language_code = @localization.try :language_code

    merge_localization

    self
  end

  def localize!(language_code, setter={})
    localizations.lang! language_code, setter
  end

  def admin_localize
    admin_localization || localize(Settings.locale.default.language)
  end  

  private

  def merge_localization
    @localization.attributes.keys.each do |name|
      instance_eval "

        def #{name}
          @localization.#{name}
        end

        def #{name}=(value)
          @localization.#{name} = value
        end

      " unless ['id', 'created_at', 'updated_at',
                "#{self.class.name.demodulize.underscore}_id"].include?(name)
    end
  end
end
