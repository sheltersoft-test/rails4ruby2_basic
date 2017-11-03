class ResourceSpec < ActiveRecord::Base
	validates :name, :presence => true, uniqueness: true, :length => {:maximum => 100}
	has_many :resources
end
