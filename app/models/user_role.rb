class UserRole < ActiveRecord::Base
	
	belongs_to :user
	enum role: ["EXECUTIVE","DIRECTOR","DENTIST"]
end
