class Setting < ActiveRecord::Base

	belongs_to :brand, inverse_of: :settings
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"
  belongs_to :updater, class_name: "User", foreign_key: "updater_id"

  validates :brand, :presence => true
end
