module Localization
  extend ActiveSupport::Concern

  included do
    localizable_name = name.demodulize.underscore
    localizable_name.slice! '_localization'

    class_eval "
      belongs_to :#{localizable_name}, inverse_of: :#{localizable_name}_localizations, autosave: true

      validates_presence_of :#{localizable_name}
      validates_uniqueness_of :language_code, scope: [:#{localizable_name}_id]
    "

    # enum language_code: { EN: 0, JA: 1 }
    enum language_code: Settings.locale.languages.map{|d| d['code']}

    validates_length_of :language_code, maximum: 10
  end
end
