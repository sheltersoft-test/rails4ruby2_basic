class Feedback < ActiveRecord::Base
  
  enum subject: ['BUG', 'DEVELOPMENT_IDEA']

  belongs_to :brand, inverse_of: :feedbacks
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"

  validates :brand, :presence => true
  validates :sender, :presence => true
  validates :message, :length => {:maximum => 65535, :allow_blank => true}  
end
