# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171102065614) do

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "brands", force: :cascade do |t|
    t.string   "name",               limit: 100,                   null: false
    t.string   "slug",               limit: 100
    t.string   "custom_domain",      limit: 100
    t.string   "custom_domain_type", limit: 100
    t.string   "redirect_domain",    limit: 100
    t.string   "prefix",             limit: 10,                    null: false
    t.text     "description",        limit: 65535
    t.string   "phone_number",       limit: 50
    t.string   "email",              limit: 50
    t.string   "site_description",   limit: 255
    t.string   "site_keywords",      limit: 255
    t.string   "site_title",         limit: 255
    t.string   "country_code",       limit: 255
    t.string   "string",             limit: 255
    t.string   "currency_code",      limit: 255
    t.string   "currency_sign",      limit: 255
    t.boolean  "is_active",                        default: true,  null: false
    t.boolean  "is_deleted",                       default: false, null: false
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "logo_file_name",     limit: 255
    t.string   "logo_content_type",  limit: 255
    t.integer  "logo_file_size",     limit: 4
    t.datetime "logo_updated_at"
  end

  add_index "brands", ["name"], name: "index_brands_on_name", unique: true, using: :btree
  add_index "brands", ["prefix"], name: "index_brands_on_prefix", unique: true, using: :btree

  create_table "feedbacks", force: :cascade do |t|
    t.integer  "brand_id",   limit: 4,                     null: false
    t.integer  "sender_id",  limit: 4,                     null: false
    t.integer  "subject",    limit: 4,     default: 0,     null: false
    t.text     "message",    limit: 65535
    t.boolean  "is_active",                default: true,  null: false
    t.boolean  "is_deleted",               default: false, null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "language_skill_l10ns", force: :cascade do |t|
    t.integer  "language_skill_id", limit: 4,                   null: false
    t.string   "name",              limit: 100,                 null: false
    t.integer  "language_code",     limit: 4,   default: 0,     null: false
    t.boolean  "is_active",                     default: true,  null: false
    t.boolean  "is_deleted",                    default: false, null: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  add_index "language_skill_l10ns", ["language_skill_id", "language_code"], name: "idx_l_skill_l10ns_l_skill_id_language_code", unique: true, using: :btree

  create_table "language_skills", force: :cascade do |t|
    t.integer  "brand_id",   limit: 4,                 null: false
    t.boolean  "is_active",            default: true,  null: false
    t.boolean  "is_deleted",           default: false, null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "resource_specs", force: :cascade do |t|
    t.string   "name",       limit: 100,                 null: false
    t.boolean  "limited",                default: false, null: false
    t.boolean  "is_active",              default: true,  null: false
    t.boolean  "is_deleted",             default: false, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "resource_specs", ["name"], name: "index_resource_specs_on_name", unique: true, using: :btree

  create_table "resource_types", force: :cascade do |t|
    t.string   "name",       limit: 100,                 null: false
    t.boolean  "is_active",              default: true,  null: false
    t.boolean  "is_deleted",             default: false, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "resource_types", ["name"], name: "index_resource_types_on_name", unique: true, using: :btree

  create_table "resources", force: :cascade do |t|
    t.integer  "resource_holder_id",    limit: 4,                   null: false
    t.string   "resource_holder_type",  limit: 255,                 null: false
    t.integer  "resource_spec_id",      limit: 4,                   null: false
    t.integer  "resource_type_id",      limit: 4,                   null: false
    t.string   "media_attachment_name", limit: 255
    t.boolean  "limited",                           default: false, null: false
    t.boolean  "is_active",                         default: true,  null: false
    t.boolean  "is_deleted",                        default: false, null: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "media_file_name",       limit: 255
    t.string   "media_content_type",    limit: 255
    t.integer  "media_file_size",       limit: 4
    t.datetime "media_updated_at"
  end

  create_table "settings", force: :cascade do |t|
    t.integer  "brand_id",      limit: 4,                   null: false
    t.string   "setting_label", limit: 255,                 null: false
    t.string   "setting_value", limit: 255
    t.integer  "creator_id",    limit: 4
    t.integer  "updater_id",    limit: 4
    t.boolean  "is_active",                 default: true,  null: false
    t.boolean  "is_deleted",                default: false, null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "tolk_locales", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tolk_locales", ["name"], name: "index_tolk_locales_on_name", unique: true, using: :btree

  create_table "tolk_phrases", force: :cascade do |t|
    t.text     "key",        limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tolk_translations", force: :cascade do |t|
    t.integer  "phrase_id",       limit: 4
    t.integer  "locale_id",       limit: 4
    t.text     "text",            limit: 65535
    t.text     "previous_text",   limit: 65535
    t.boolean  "primary_updated",               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tolk_translations", ["phrase_id", "locale_id"], name: "index_tolk_translations_on_phrase_id_and_locale_id", unique: true, using: :btree

  create_table "user_roles", force: :cascade do |t|
    t.integer  "user_id",    limit: 4,             null: false
    t.integer  "role",       limit: 4, default: 0, null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "user_roles", ["user_id", "role"], name: "idx_user_id_role", unique: true, using: :btree

  create_table "user_skills", force: :cascade do |t|
    t.integer  "user_id",    limit: 4,                   null: false
    t.string   "skill_type", limit: 255,                 null: false
    t.integer  "skill_id",   limit: 4,                   null: false
    t.boolean  "is_active",              default: true,  null: false
    t.boolean  "is_deleted",             default: false, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "user_skills", ["user_id", "skill_type", "skill_id"], name: "index_user_skills_on_user_id_and_skill_type_and_skill_id", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.integer  "brand_id",               limit: 4,                     null: false
    t.integer  "creator_id",             limit: 4
    t.integer  "updater_id",             limit: 4
    t.string   "email",                  limit: 255,   default: "",    null: false
    t.string   "encrypted_password",     limit: 255,   default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "first_name",             limit: 50,                    null: false
    t.string   "last_name",              limit: 50,                    null: false
    t.date     "birthdate"
    t.string   "ssn",                    limit: 50
    t.text     "address",                limit: 65535
    t.integer  "post_number",            limit: 4
    t.string   "city",                   limit: 50
    t.string   "phone_number",           limit: 50
    t.string   "personal_email",         limit: 50
    t.string   "gender",                 limit: 1
    t.string   "sv_number",              limit: 50
    t.integer  "relationship_type",      limit: 4,     default: 0,     null: false
    t.date     "contract_start_date"
    t.date     "contract_end_date"
    t.integer  "contract_type",          limit: 4,     default: 0,     null: false
    t.boolean  "contract_probation",                   default: false, null: false
    t.integer  "job_role",               limit: 4
    t.string   "other_job_role",         limit: 255
    t.integer  "specialty",              limit: 4,     default: 0,     null: false
    t.text     "languages",              limit: 65535
    t.string   "job_title",              limit: 50
    t.text     "other_business_degrees", limit: 65535
    t.boolean  "perform_dentist_work",                 default: true,  null: false
    t.integer  "language",               limit: 4
    t.text     "introduction",           limit: 65535
    t.text     "working_areas",          limit: 65535
    t.string   "linkedin_url",           limit: 255
    t.string   "facebook_url",           limit: 255
    t.string   "twitter_url",            limit: 255
    t.boolean  "registered",                           default: false, null: false
    t.boolean  "intermediate",                         default: false, null: false
    t.boolean  "is_active",                            default: true,  null: false
    t.boolean  "is_deleted",                           default: false, null: false
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
