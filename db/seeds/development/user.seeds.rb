# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'seedbank'
require 'ffaker'

puts "\n> -- Seeds::Development::Brand --------------------------"

brand = Brand.find_or_create_by!(name: 'SYH', prefix: 'SYH', phone_number: '99999999', email: 'admin@dbm.fi', :slug => 'dbm')
brand.logo = File.open("#{Rails.root}/app/assets/images/straumann-logo.png")

brand.country_code = "FI" 
brand.currency_code = "EUR"
brand.currency_sign = "€"
brand.save!

puts "\n> -- Seeds::Development::Brand::LanguageSkill --------------------------"

  language_skill_arr_en = ["Finnish", "Swedish", "English", "German", "French", "Italian", "Spanish", "Russian", "Estonian"]
  language_skill_arr_fi = ["Suomi", "Ruotsi", "Englanti", "Saksa", "Ranska", "Italia", "Espanja", "Venäjä", "Viro"]

  language_skill_arr_en.each do |language_skill_name|
    language_skill_l10n = LanguageSkillLocalization.where(:language_code => 'EN', :name => language_skill_name).first
    unless language_skill_l10n and language_skill_l10n.language_skill.brand == brand
      language_skill = brand.language_skills.create
      language_skill_l10n = language_skill.localizations.create!(:language_code => 'EN', :name => language_skill_name)
    end
  end
  
  # language_skill_arr_fi.each do |language_skill_name|
  #   language_skill_l10n = LanguageSkillLocalization.where(:language_code => 'FI', :name => language_skill_name).first
  #   unless language_skill_l10n and language_skill_l10n.language_skill.brand == brand
  #     language_skill = brand.language_skills.create
  #     language_skill_l10n = language_skill.localizations.create!(:language_code => 'FI', :name => language_skill_name)
  #   end
  # end

puts "\n> -- Seeds::Development::Brand::User  --------------------------"

  executive = brand.users.find_by(email: 'executive@dbm.fi')
  director = brand.users.find_by(email: 'director@dbm.fi')
  dentist = brand.users.find_by(email: 'dentist@dbm.fi')
  admin_user = AdminUser.find_by(email: 'admin@example.com')
  
  unless executive
    executive = brand.users.create!(email: 'executive@dbm.fi',first_name: 'Executive', last_name: 'executive', password: 'password', password_confirmation: 'password', registered: true)
    UserRole.create(:role => 0, :user => executive)
  end
  unless director
    director = brand.users.create!(email: 'director@dbm.fi',first_name: 'Director', last_name: 'director', password: 'password', password_confirmation: 'password', registered: true)
    UserRole.create(:role => 1, :user => director)
  end
  unless dentist
    dentist = brand.users.create!(email: 'dentist@dbm.fi',first_name: 'dentist', last_name: 'Dentist', password: 'password', password_confirmation: 'password', registered: true)
    UserRole.create(:role => 2, :user => dentist)
  end

  for i in 1..15
    genderArr = ["M","F"]

    executive = brand.users.create_with(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name,
      job_title: FFaker::Job.title, job_role: 0, post_number: FFaker::AddressIN.pincode, address: FFaker::Address.secondary_address,
      password: 'password', password_confirmation: 'password', personal_email: FFaker::Internet.email, gender: genderArr[rand(genderArr.length)],
      phone_number: FFaker::PhoneNumber.short_phone_number, :city => FFaker::AddressIN.city, birthdate: FFaker::IdentificationESCO.expedition_date, registered: true).find_or_create_by!(email: "executive#{i}@dbm.fi")
    UserRole.create(:role => 0, :user => executive)

    director = brand.users.create_with(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name,
      job_title: FFaker::Job.title, job_role: 0, post_number: FFaker::AddressIN.pincode, address: FFaker::Address.secondary_address,
      password: 'password', password_confirmation: 'password', personal_email: FFaker::Internet.email, gender: genderArr[rand(genderArr.length)],
      phone_number: FFaker::PhoneNumber.short_phone_number, :city => FFaker::AddressIN.city, birthdate: FFaker::IdentificationESCO.expedition_date, registered: true).find_or_create_by!(email: "director#{i}@dbm.fi")
    UserRole.create(:role => 1, :user => director)

    dentist = brand.users.create_with(first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name,
      job_title: FFaker::Job.title, job_role: 0, post_number: FFaker::AddressIN.pincode, address: FFaker::Address.secondary_address,
      password: 'password', password_confirmation: 'password', personal_email: FFaker::Internet.email, gender: genderArr[rand(genderArr.length)],
      phone_number: FFaker::PhoneNumber.short_phone_number, :city => FFaker::AddressIN.city, birthdate: FFaker::IdentificationESCO.expedition_date, registered: true).find_or_create_by!(email: "dentist#{i}@dbm.fi")
    UserRole.create(:role => 2, :user => dentist)
  end

  unless admin_user
    AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
  end