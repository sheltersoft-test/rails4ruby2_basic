# require 'localization'

class LanguageSkillLocalization < ActiveRecord::Base
  include Localization

  self.table_name = 'language_skill_l10ns'

  validates :name, :presence => true, :length => {:maximum => 100}
end