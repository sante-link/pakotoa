# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_23_210741) do

  create_table "affiliations", force: :cascade do |t|
    t.integer "user_id"
    t.integer "certificate_authority_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["certificate_authority_id"], name: "index_affiliations_on_certificate_authority_id"
    t.index ["user_id"], name: "index_affiliations_on_user_id"
  end

  create_table "certificates", force: :cascade do |t|
    t.string "serial"
    t.integer "issuer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "type", default: "Certificate"
    t.string "subject"
    t.text "certificate"
    t.datetime "not_before"
    t.datetime "not_after"
    t.text "key"
    t.decimal "next_serial"
    t.integer "policy_id"
    t.string "export_root"
    t.datetime "revoked_at"
    t.string "certify_for", default: "2 years from now"
    t.index ["issuer_id"], name: "index_certificates_on_issuer_id"
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer "resource_owner_id", null: false
    t.integer "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer "resource_owner_id"
    t.integer "application_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "oids", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.string "oid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "default_description"
  end

  create_table "policies", force: :cascade do |t|
    t.string "name"
  end

  create_table "subject_attributes", force: :cascade do |t|
    t.integer "oid_id"
    t.integer "policy_id"
    t.string "default"
    t.integer "min"
    t.integer "max"
    t.string "strategy"
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "description"
    t.index ["oid_id"], name: "index_subject_attributes_on_oid_id"
    t.index ["policy_id"], name: "index_subject_attributes_on_policy_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "time_zone"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
