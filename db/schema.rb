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

ActiveRecord::Schema.define(version: 20160131150935) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "building_id"
    t.integer  "actionable_id"
    t.string   "actionable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "activities", ["actionable_id"], name: "index_activities_on_actionable_id", using: :btree
  add_index "activities", ["actionable_type", "actionable_id"], name: "index_activities_on_actionable_type_and_actionable_id", using: :btree
  add_index "activities", ["building_id"], name: "index_activities_on_building_id", using: :btree
  add_index "activities", ["user_id"], name: "index_activities_on_user_id", using: :btree

  create_table "alerts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "building_id"
    t.text     "message"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "alerts", ["building_id"], name: "index_alerts_on_building_id", using: :btree
  add_index "alerts", ["user_id"], name: "index_alerts_on_user_id", using: :btree

  create_table "attachinary_files", force: :cascade do |t|
    t.integer  "attachinariable_id"
    t.string   "attachinariable_type"
    t.string   "scope"
    t.string   "public_id"
    t.string   "version"
    t.integer  "width"
    t.integer  "height"
    t.string   "format"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attachinary_files", ["attachinariable_type", "attachinariable_id", "scope"], name: "by_scoped_parent", using: :btree

  create_table "buildings", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.string   "invitation_link"
    t.float    "latitude"
    t.float    "float"
    t.float    "longitude"
    t.boolean  "active",          default: true
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "slug"
  end

  add_index "buildings", ["address"], name: "index_buildings_on_address", unique: true, using: :btree
  add_index "buildings", ["slug"], name: "index_buildings_on_slug", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "parent_category_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "slug"
    t.string   "color"
  end

  add_index "categories", ["slug"], name: "index_categories_on_slug", unique: true, using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "parent_comment_id"
    t.text     "body"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.boolean  "flagged",           default: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "comments", ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "starts"
    t.integer  "building_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "events", ["building_id"], name: "index_events_on_building_id", using: :btree
  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "invitations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "building_id"
    t.string   "token"
    t.string   "email"
    t.datetime "redeemed_at"
    t.string   "type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "invitations", ["building_id"], name: "index_invitations_on_building_id", using: :btree
  add_index "invitations", ["token"], name: "index_invitations_on_token", using: :btree
  add_index "invitations", ["user_id"], name: "index_invitations_on_user_id", using: :btree

  create_table "manager_invitations", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "email"
    t.string   "status",     default: "new"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "building_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "membership_type", default: "Guest"
  end

  add_index "memberships", ["membership_type", "building_id", "user_id"], name: "user_building_membership", unique: true, using: :btree
  add_index "memberships", ["user_id", "building_id", "membership_type"], name: "user_buidling_membership", unique: true, using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.integer  "building_id"
    t.text     "body"
    t.boolean  "is_read",      default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "slug"
  end

  add_index "messages", ["building_id", "recipient_id"], name: "index_messages_on_building_id_and_recipient_id", using: :btree
  add_index "messages", ["building_id", "sender_id"], name: "index_messages_on_building_id_and_sender_id", using: :btree
  add_index "messages", ["slug"], name: "index_messages_on_slug", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "notifiable_id"
    t.string   "notifiable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "notifications", ["notifiable_id"], name: "index_notifications_on_notifiable_id", using: :btree
  add_index "notifications", ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable_type_and_notifiable_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "category_id"
    t.integer  "postable_id"
    t.string   "postable_type"
    t.string   "title"
    t.string   "slug"
    t.text     "body"
    t.boolean  "flagged",       default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "posts", ["postable_id"], name: "index_posts_on_postable_id", using: :btree
  add_index "posts", ["postable_type", "postable_id"], name: "index_posts_on_postable_type_and_postable_id", using: :btree
  add_index "posts", ["slug"], name: "index_posts_on_slug", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "short_urls", force: :cascade do |t|
    t.string   "token"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "short_urls", ["token"], name: "index_short_urls_on_token", using: :btree

  create_table "tenancies", force: :cascade do |t|
    t.integer  "unit_id"
    t.integer  "user_id"
    t.integer  "building_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "building_id"
    t.string   "title"
    t.text     "body"
    t.string   "severity"
    t.string   "status"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "tickets", ["building_id", "severity"], name: "index_tickets_on_building_id_and_severity", using: :btree
  add_index "tickets", ["building_id", "status"], name: "index_tickets_on_building_id_and_status", using: :btree

  create_table "units", force: :cascade do |t|
    t.integer  "building_id"
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "units", ["building_id"], name: "index_units_on_building_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                    default: "",   null: false
    t.string   "encrypted_password",       default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "username"
    t.string   "phone"
    t.boolean  "use_my_username",          default: true
    t.boolean  "ok_to_send_text_messages", default: true
    t.string   "slug"
    t.integer  "invitation_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "provider"
    t.string   "uid"
    t.integer  "profile_status",           default: 0
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",        default: 0
    t.string   "invitation_type"
    t.integer  "invited_to_building_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_id"], name: "index_users_on_invitation_id", using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["profile_status"], name: "index_users_on_profile_status", using: :btree
  add_index "users", ["provider"], name: "index_users_on_provider", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "verification_requests", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "building_id"
    t.string   "status",      default: "New"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "verification_requests", ["building_id"], name: "index_verification_requests_on_building_id", using: :btree
  add_index "verification_requests", ["user_id"], name: "index_verification_requests_on_user_id", using: :btree

  create_table "verifications", force: :cascade do |t|
    t.integer  "building_id"
    t.integer  "user_id"
    t.integer  "verifier_id"
    t.integer  "verification_request_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "verifications", ["building_id"], name: "index_verifications_on_building_id", using: :btree
  add_index "verifications", ["user_id"], name: "index_verifications_on_user_id", using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  add_foreign_key "activities", "buildings"
  add_foreign_key "activities", "users"
  add_foreign_key "alerts", "buildings"
  add_foreign_key "alerts", "users"
  add_foreign_key "comments", "users"
  add_foreign_key "events", "buildings"
  add_foreign_key "events", "users"
  add_foreign_key "invitations", "buildings"
  add_foreign_key "invitations", "users"
  add_foreign_key "memberships", "buildings"
  add_foreign_key "memberships", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "posts", "categories"
  add_foreign_key "posts", "users"
  add_foreign_key "tickets", "buildings"
  add_foreign_key "tickets", "users"
  add_foreign_key "verification_requests", "buildings"
  add_foreign_key "verification_requests", "users"
  add_foreign_key "verifications", "buildings"
  add_foreign_key "verifications", "users"
end
