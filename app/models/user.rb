class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum contract_type: ['NONE', 'INDEFINITELY_VALID', 'TIME_LIMITED']
  enum language: ["FI","EN"]
  enum relationship_type: ['NA', 'SALARY_BASED', 'PARTNER']
  enum job_role: ['CEO','CFO','MARKETING_DIRECTOR','ADMINISTRATIVE_DIRECTOR','SALES_DIRECTOR','CHIEF_OF_OPERATIONS','RESPONSIBLE_MANAGER', 'SERVICE_MANAGER', 'LEADING_DENTIST']
  
  belongs_to :brand, inverse_of: :users
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"
  belongs_to :updater, class_name: "User", foreign_key: "updater_id"

  has_one :user_role, inverse_of: :user, dependent: :destroy
  accepts_nested_attributes_for :user_role, allow_destroy: true

  has_many :user_skills, inverse_of: :user, dependent: :destroy
  accepts_nested_attributes_for :user_skills

  has_many :language_skills, :through => :user_skills, :source => :skill, :source_type => 'LanguageSkill'
  
  include HasResources

  validates :brand, :presence => true
  validates :first_name, :presence => true, :length => {:maximum => 50}
  validates :last_name, :presence => true, :length => {:maximum => 50}
  validates :ssn, :length => {:maximum => 50, :allow_blank => true}
  validates :address, :length => {:maximum => 500, :allow_blank => true}
  validates :city, :length => {:maximum => 50, :allow_blank => true}
  validates :phone_number, :length => {:maximum => 50, :allow_blank => true}
  validates :personal_email, :length => {:maximum => 50, :allow_blank => true}
  validates :gender, :length => {:maximum => 1, :allow_blank => true}
  validates :other_business_degrees, :length => {:maximum => 65535, :allow_blank => true}
  validates :introduction, :length => {:maximum => 65535, :allow_blank => true}
  validates :working_areas, :length => {:maximum => 65535, :allow_blank => true}
  validate :validate_end_date_before_start_date
  
  validates_presence_of   :email, :length => {:maximum => 15, :allow_blank => true}, if: :email_required?
  validates_uniqueness_of :email, :scope => :brand_id, :if => :email_changed?
  validates_format_of     :email, :with => Devise.email_regexp, :allow_blank => true, :if => :email_changed?
  
  validates_presence_of     :password, if: :password_required?
  validates_confirmation_of :password, if: :password_required?
  validates_presence_of     :password_confirmation, if: :password_required?
  validates_length_of       :password, within: Devise.password_length, allow_blank: true
    
  scope :executives, -> { joins(:user_role).where('user_roles.role = ?', UserRole.roles['EXECUTIVE']) }
  scope :directors, -> { joins(:user_role).where('user_roles.role = ?', UserRole.roles['DIRECTOR']) }
  scope :dentists, -> { joins(:user_role).where('user_roles.role = ?', UserRole.roles['DENTIST']) }

  default_scope {where(is_deleted: false)}
  
  def executive?
    self.user_role.role == 'EXECUTIVE'
  end

  def director?
    self.user_role.role == 'DIRECTOR'
  end

  def dentist?
    self.user_role.role == 'DENTIST'
  end

  def name
    self.first_name.to_s + " " + self.last_name.to_s
  end

  def email_required?
    true
  end

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  def self.valid_contract_types
    self.contract_types.keys - [self.contract_types.keys[0]]
  end

  def validate_end_date_before_start_date
    if self.contract_end_date && self.contract_start_date
      errors.add(:contract_end_date, I18n.t("user.contract_end_date_validation")) if self.contract_end_date < self.contract_start_date
    end
  end

  def can_update_user? user
    if self.executive?
      true
    elsif self.director? or self.dentist?
      user.executive? ? false : true
    else
      false
    end
  end

  def user_job_roles
    if self.executive?
      ['CEO','CFO','MARKETING_DIRECTOR','ADMINISTRATIVE_DIRECTOR','SALES_DIRECTOR','CHIEF_OF_OPERATIONS']
    elsif self.director?
      ['RESPONSIBLE_MANAGER', 'SERVICE_MANAGER', 'LEADING_DENTIST']
    end
  end
end