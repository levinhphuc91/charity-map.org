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

ActiveRecord::Schema.define(version: 20140712092634) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "categories", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "configurations", force: true do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "donations", force: true do |t|
    t.string   "euid"
    t.string   "status"
    t.integer  "user_id"
    t.float    "amount"
    t.text     "note"
    t.string   "collection_method"
    t.integer  "project_reward_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_reward_quantity"
    t.boolean  "anon"
    t.string   "admin_note"
  end

  add_index "donations", ["project_id"], name: "index_donations_on_project_id", using: :btree
  add_index "donations", ["project_reward_id"], name: "index_donations_on_project_reward_id", using: :btree
  add_index "donations", ["user_id"], name: "index_donations_on_user_id", using: :btree

  create_table "ext_donations", force: true do |t|
    t.integer  "project_id"
    t.float    "amount"
    t.text     "note"
    t.string   "collection_method"
    t.string   "donor"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "collection_time"
    t.string   "email"
    t.string   "phone"
    t.boolean  "anon"
    t.string   "status"
  end

  add_index "ext_donations", ["project_id"], name: "index_ext_donations_on_project_id", using: :btree

  create_table "ext_projects", force: true do |t|
    t.string   "photo"
    t.string   "title"
    t.string   "location"
    t.float    "funding_goal"
    t.integer  "number_of_donors"
    t.datetime "executed_at"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
  end

  add_index "ext_projects", ["user_id"], name: "index_ext_projects_on_user_id", using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", unique: true, using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "gift_cards", force: true do |t|
    t.string   "recipient_email"
    t.float    "amount"
    t.hstore   "references"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "status"
    t.string   "master_transaction_id"
    t.string   "token"
  end

  create_table "impressions", force: true do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", using: :btree
  add_index "impressions", ["user_id"], name: "index_impressions_on_user_id", using: :btree

  create_table "invites", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
    t.string   "status"
  end

  add_index "invites", ["project_id"], name: "index_invites_on_project_id", using: :btree

  create_table "managements", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "managements", ["project_id"], name: "index_managements_on_project_id", using: :btree
  add_index "managements", ["user_id"], name: "index_managements_on_user_id", using: :btree

  create_table "messages", force: true do |t|
    t.string   "topic"
    t.text     "body"
    t.integer  "received_messageable_id"
    t.string   "received_messageable_type"
    t.integer  "sent_messageable_id"
    t.string   "sent_messageable_type"
    t.boolean  "opened",                     default: false
    t.boolean  "recipient_delete",           default: false
    t.boolean  "sender_delete",              default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
    t.boolean  "recipient_permanent_delete", default: false
    t.boolean  "sender_permanent_delete",    default: false
  end

  add_index "messages", ["ancestry"], name: "index_messages_on_ancestry", using: :btree
  add_index "messages", ["sent_messageable_id", "received_messageable_id"], name: "acts_as_messageable_ids", using: :btree

  create_table "organization_lists", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "website"
    t.string   "facebook"
    t.text     "address"
    t.string   "legal_entity"
    t.string   "geographical_area"
    t.hstore   "category"
    t.string   "year_of_establishment"
    t.text     "key_contact"
    t.text     "bank_account"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "outgoing_mail_logs", force: true do |t|
    t.string   "email"
    t.string   "event"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_comments", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo"
  end

  add_index "project_comments", ["project_id"], name: "index_project_comments_on_project_id", using: :btree
  add_index "project_comments", ["user_id"], name: "index_project_comments_on_user_id", using: :btree

  create_table "project_follows", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_follows", ["project_id"], name: "index_project_follows_on_project_id", using: :btree
  add_index "project_follows", ["user_id"], name: "index_project_follows_on_user_id", using: :btree

  create_table "project_rewards", force: true do |t|
    t.float    "value"
    t.text     "description"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "photo"
    t.integer  "quantity"
    t.boolean  "shipping_fee_applied"
  end

  add_index "project_rewards", ["project_id"], name: "index_project_rewards_on_project_id", using: :btree

  create_table "project_updates", force: true do |t|
    t.text     "content"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo"
    t.string   "title"
  end

  add_index "project_updates", ["project_id"], name: "index_project_updates_on_project_id", using: :btree

  create_table "projects", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_date"
    t.datetime "end_date"
    t.float    "funding_goal"
    t.string   "location"
    t.string   "photo"
    t.integer  "user_id"
    t.string   "status"
    t.string   "slug"
    t.text     "brief"
    t.string   "video"
    t.boolean  "unlisted"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.text     "invite_email_content"
    t.string   "invite_sms_content"
    t.string   "short_code"
    t.text     "bank_info"
    t.boolean  "item_based"
    t.boolean  "terms_of_service"
  end

  add_index "projects", ["slug"], name: "index_projects_on_slug", unique: true, using: :btree
  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree

  create_table "recommendations", force: true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recommendations", ["project_id"], name: "index_recommendations_on_project_id", using: :btree
  add_index "recommendations", ["user_id"], name: "index_recommendations_on_user_id", using: :btree

  create_table "redirect_tokens", force: true do |t|
    t.string   "value"
    t.string   "redirect_class_name"
    t.string   "redirect_class_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "extra_params"
  end

  create_table "relationships", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "settings", force: true do |t|
    t.string   "var",         null: false
    t.text     "value"
    t.integer  "target_id",   null: false
    t.string   "target_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["target_type", "target_id", "var"], name: "index_settings_on_target_type_and_target_id_and_var", unique: true, using: :btree

  create_table "tokens", force: true do |t|
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ext_donation_id"
    t.string   "status"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_name"
    t.text     "address"
    t.string   "city"
    t.text     "bio"
    t.string   "phone"
    t.boolean  "staff"
    t.string   "avatar"
    t.boolean  "verified_by_phone"
    t.string   "provider"
    t.string   "uid"
    t.hstore   "facebook_credentials"
    t.boolean  "org"
    t.hstore   "figures"
    t.float    "latitude"
    t.float    "longitude"
    t.hstore   "facebook_friends"
    t.string   "api_token"
    t.string   "website"
    t.boolean  "notify_via_email"
    t.boolean  "notify_via_sms"
    t.boolean  "notify_via_facebook"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "verifications", force: true do |t|
    t.string   "code"
    t.integer  "user_id"
    t.string   "channel"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.hstore   "receipt"
  end

  add_index "verifications", ["user_id"], name: "index_verifications_on_user_id", using: :btree

end
