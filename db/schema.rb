# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_08_25_182819) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "affiliations", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "certificate_authority_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["certificate_authority_id"], name: "index_affiliations_on_certificate_authority_id"
    t.index ["user_id"], name: "index_affiliations_on_user_id"
  end

  create_table "certificates", id: :serial, force: :cascade do |t|
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
    t.string "crl_ttl", default: "1 week from now"
    t.index ["issuer_id"], name: "index_certificates_on_issuer_id"
  end

  create_table "oids", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.string "oid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "default_description"
  end

  create_table "policies", id: :serial, force: :cascade do |t|
    t.string "name"
  end

  create_table "subject_attributes", id: :serial, force: :cascade do |t|
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

  create_table "users", id: :serial, force: :cascade do |t|
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
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
