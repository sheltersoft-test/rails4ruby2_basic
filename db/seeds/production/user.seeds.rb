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

brand = Brand.find_or_create_by!(name: 'STRAUMANN', prefix: 'dsd', phone_number: '99999999', email: 'admin@straumann.fi', :slug => 'straumann')
brand.logo = File.open("#{Rails.root}/app/assets/images/straumann-digital-logo.png")
brand.save!

puts "\n> -- Seeds::Development::Brand::Setting::SalesAreas  --------------------------"

  setting = Setting.find_or_create_by!(brand: brand, technician_price: "2300", supplier_price: "200", dentist_billing_price: "200", avg_purchase_size_per_patient: "1,5", implant_total_price: "2700", first_tower_value: "2", second_tower_value: "7", third_tower_value: "10", fourth_tower_value: "12", common_tax_base: 24, reduced_tax_base_1: 14, reduced_tax_base_2: 10, tax_free_service: 0, weights: "{'JAN'=>'0,1', 'FEB'=>'0,1', 'MAR'=>'0,1', 'APR'=>'0,2', 'MAY'=>'0,2', 'JUN'=>'0,3'}")
  sales_area_1 = setting.sales_areas.find_or_create_by!(sales_area_name: "Etelä-Suomi")
  sales_area_2 = setting.sales_areas.find_or_create_by!(sales_area_name: "Länsi-Suomi")
  sales_area_3 = setting.sales_areas.find_or_create_by!(sales_area_name: "Itä – ja Pohjois-Suomi")
  sales_area_4 = setting.sales_areas.find_or_create_by!(sales_area_name: "Keski-Suomi")
  setting.billing_addresses.create! if setting.billing_addresses.first.nil?

puts "\n> -- Seeds::Development::Brand::LanguageSkill --------------------------"

  language_skill_arr = ["Finnish", "Swedish", "English", "German", "French", "Italian", "Spanish", "Russian", "Estonian"]

  language_skill_arr.each do |language_skill_name|
    language_skill_l10n = LanguageSkillLocalization.where(:language_code => 'EN', :name => language_skill_name).first
    unless language_skill_l10n and language_skill_l10n.language_skill.brand == brand
      language_skill = brand.language_skills.create
      language_skill_l10n = language_skill.localizations.create!(:language_code => 'EN', :name => language_skill_name)
    end
  end

puts "\n> -- Seeds::Development::Brand::User  --------------------------"

  manager1 = brand.users.find_by(email: 'manager@straumann.fi')
  sales1 = brand.users.find_by(email: 'sales@straumann.fi')
  admin_user = AdminUser.find_by(email: 'admin@straumann.fi')

  manager2 = brand.users.find_by(email: 'fenux.test.user+1@gmail.com')
  sales2 = brand.users.find_by(email: 'fenux.test.user+2@gmail.com')  

  
  unless manager1
    manager1 = brand.users.create!(role: 0, email: 'manager@straumann.fi',first_name: 'Manager', last_name: 'Manager', password: 'password', password_confirmation: 'password', registered: true)
  end

  unless manager2
    manager2 = brand.users.create!(role: 0, email: 'fenux.test.user+1@gmail.com',first_name: 'DSD', last_name: 'Manager', password: 'password', password_confirmation: 'password', registered: true)
  end  

  unless sales1
    sales1 = brand.users.create!(role: 1, email: 'sales@straumann.fi', first_name: 'Sales', last_name: 'Sales', password: 'password', password_confirmation: 'password', registered: true)
  end

  unless sales2
    sales2 = brand.users.create!(role: 1, email: 'fenux.test.user+2@gmail.com', first_name: 'DSD', last_name: 'Sales Rep.', password: 'password', password_confirmation: 'password', registered: true)
  end  

  unless admin_user
    AdminUser.create!(email: 'admin@straumann.fi', password: 'p@ssw0rd', password_confirmation: 'p@ssw0rd')
  end

puts "\n> -- Seeds:Development::Brand::Survey ---------------------------------"
  survey = Referral::Survey.create(brand: brand, cover_letter: I18n.t("referral_event.satisfaction.cover_letter_survey"))

  [I18n.t("referral_event.send_questionnaire_to_participant.question_one"),I18n.t("referral_event.send_questionnaire_to_participant.question_two"),I18n.t("referral_event.send_questionnaire_to_participant.question_three")].each do |question_name|
    survey.survey_questions.create!(name: question_name, survey_type: 0)
  end

  [I18n.t("referral_event.send_questionnaire_to_participant.speakers_question_one"),I18n.t("referral_event.send_questionnaire_to_participant.speakers_question_two")].each do |question_name|
    survey.survey_questions.create!(name: question_name, survey_type: 1)
  end 

puts "\n> -- Seeds:Development::Brand::Templates ---------------------------------"

  brand.templates.find_or_create_by!(name: 'template_1')
  brand.templates.find_or_create_by!(name: 'template_2')
  brand.templates.find_or_create_by!(name: 'template_3')