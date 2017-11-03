# require 'localizable'

class LanguageSkill < ActiveRecord::Base
  include Localizable

  belongs_to :brand, inverse_of: :language_skills

  validates :brand, presence: true
end
