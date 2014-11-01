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

ActiveRecord::Schema.define(version: 20141101185629) do

  create_table "authentication_tokens", force: true do |t|
    t.string   "token"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "help_request_rescuers", force: true do |t|
    t.integer  "user_id"
    t.integer  "help_request_id"
    t.string   "state"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "help_requests", force: true do |t|
    t.integer  "user_id"
    t.text     "description"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
  end

  create_table "mobile_devices", force: true do |t|
    t.string   "model"
    t.string   "system_name"
    t.string   "system_version"
    t.boolean  "multitasking",   default: false, null: false
    t.integer  "user_id"
    t.integer  "integer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "oauths", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauths", ["provider", "uid"], name: "index_oauths_on_provider_and_uid"

  create_table "pages", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.datetime "published_at"
    t.string   "status"
    t.boolean  "visible_in_menu"
  end

  create_table "projects", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.text     "content"
    t.string   "url"
    t.string   "itunes_url"
    t.string   "google_url"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "projects", ["created_at"], name: "index_projects_on_created_at"
  add_index "projects", ["status"], name: "index_projects_on_status"

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.boolean  "deleted",                                             default: false, null: false
    t.boolean  "enabled",                                             default: true,  null: false
    t.decimal  "latitude",                   precision: 10, scale: 6
    t.decimal  "longitude",                  precision: 10, scale: 6
    t.string   "lastname"
    t.string   "firstname"
    t.string   "name"
    t.string   "sex"
    t.date     "birthday"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.boolean  "email_verified",                                      default: false, null: false
    t.string   "email_verification_token"
    t.datetime "email_verification_sent_at"
    t.datetime "email_verified_at"
    t.string   "picture_url"
    t.string   "facebook_id"
    t.string   "google_id"
  end

end
