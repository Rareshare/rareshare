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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130427224150) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "addresses", :force => true do |t|
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "addressable_type"
    t.integer  "addressable_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "bookings", :force => true do |t|
    t.integer  "renter_id"
    t.integer  "tool_id"
    t.integer  "price"
    t.datetime "deadline"
    t.text     "sample_description"
    t.string   "state"
    t.datetime "cancelled_at"
    t.boolean  "tos_accepted"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "bookings", ["state"], :name => "index_bookings_on_state"

  create_table "helpers", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "zip"
    t.string   "phone"
    t.string   "blog"
    t.string   "listserv"
    t.string   "twitter"
    t.text     "groups"
    t.text     "other"
    t.text     "memories"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "images", :force => true do |t|
    t.string  "image"
    t.string  "integer"
    t.string  "imageable_type"
    t.string  "string"
    t.integer "imageable_id"
  end

  add_index "images", ["imageable_id", "imageable_type"], :name => "index_images_on_imageable_id_and_imageable_type"

  create_table "leases", :force => true do |t|
    t.integer  "lessor_id"
    t.integer  "lessee_id"
    t.integer  "tool_id"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "cancelled_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.boolean  "tos_accepted"
    t.string   "state"
    t.text     "description"
  end

  create_table "manufacturers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "models", :force => true do |t|
    t.string   "name"
    t.integer  "manufacturer_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "pages", :force => true do |t|
    t.string "title"
    t.string "slug"
    t.text   "content"
  end

  create_table "searches", :id => false, :force => true do |t|
    t.text    "document"
    t.integer "searchable_id"
    t.string  "searchable_type"
  end

  create_table "tool_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tools", :force => true do |t|
    t.integer  "owner_id"
    t.integer  "model_id"
    t.string   "resolution"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.text     "description"
    t.integer  "manufacturer_id"
    t.integer  "sample_size_min"
    t.integer  "sample_size_max"
    t.integer  "year_manufactured"
    t.string   "serial_number"
    t.integer  "tool_category_id"
    t.integer  "base_lead_time"
    t.decimal  "base_price",          :precision => 19, :scale => 2
    t.boolean  "can_expedite"
    t.integer  "expedited_lead_time"
    t.decimal  "expedited_price",     :precision => 19, :scale => 2
    t.text     "document"
    t.float    "latitude"
    t.float    "longitude"
  end

  create_table "user_messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.integer  "reply_to_id"
    t.boolean  "acknowledged",           :default => false
    t.text     "body"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "messageable_id"
    t.string   "messageable_type"
    t.integer  "originating_message_id"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "provider"
    t.string   "uid"
    t.string   "image_url"
    t.string   "linkedin_profile_url"
    t.string   "title"
    t.string   "organization"
    t.string   "education"
    t.text     "bio"
    t.string   "primary_phone"
    t.string   "secondary_phone"
    t.text     "qualifications"
    t.integer  "tools_count",            :default => 0
    t.string   "avatar"
    t.boolean  "admin"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
