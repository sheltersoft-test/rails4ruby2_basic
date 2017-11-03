class UserSkill < MasterBase

  belongs_to :user, inverse_of: :user_skills
  belongs_to :skill, polymorphic: true

  validates :user, :presence => true
  validates :skill, :presence => true

  validates_uniqueness_of :skill_id, :scope => [:user_id, :skill_type]

end
