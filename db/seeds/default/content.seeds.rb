# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'seedbank'

puts "\n> -- Seeds::Development::ResourceType --------------------------"

ResourceType.find_or_create_by!(name: 'IMAGE')
ResourceType.find_or_create_by!(name: 'DOCUMENT')

puts "\n> -- Seeds::Development::ResourceSpec --------------------------"

ResourceSpec.find_or_create_by!(name: 'LOGO')
ResourceSpec.find_or_create_by!(name: 'USER_PHOTO')
ResourceSpec.find_or_create_by!(name: 'WRITTEN_CONTRACT', limited: true)
ResourceSpec.find_or_create_by!(name: 'CONTRACT_ATTACHMENT', limited: true)
ResourceSpec.find_or_create_by!(name: 'LKV_CERTIFICATE', limited: true)
ResourceSpec.find_or_create_by!(name: 'NDA', limited: true)
ResourceSpec.find_or_create_by!(name: 'ATTACHMENT', limited: true)