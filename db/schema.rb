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

ActiveRecord::Schema.define(version: 2020_07_01_211326) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "actions", force: :cascade do |t|
    t.bigint "flow_id"
    t.integer "order"
    t.text "subject"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "type"
    t.integer "delay", default: 0
    t.string "name"
    t.index ["flow_id"], name: "index_actions_on_flow_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "appointments", force: :cascade do |t|
    t.string "email"
    t.string "acuity_appointment_id", null: false
    t.string "mindbody_class_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "starts_at"
    t.index ["acuity_appointment_id", "mindbody_class_id"], name: "acuity_mindbody_index", unique: true
    t.index ["acuity_appointment_id"], name: "index_appointments_on_acuity_appointment_id"
    t.index ["email"], name: "index_appointments_on_email"
    t.index ["mindbody_class_id"], name: "index_appointments_on_mindbody_class_id"
  end

  create_table "flows", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "zendesk_status_id"
    t.bigint "zendesk_stage_id"
    t.index ["zendesk_stage_id"], name: "index_flows_on_zendesk_stage_id"
    t.index ["zendesk_status_id"], name: "index_flows_on_zendesk_status_id"
  end

  create_table "histories", force: :cascade do |t|
    t.text "text", null: false
    t.string "subject_type"
    t.bigint "subject_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["subject_type", "subject_id"], name: "index_histories_on_subject_type_and_subject_id"
  end

  create_table "leads", force: :cascade do |t|
    t.string "name"
    t.string "phone_number"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "zendesk_id"
    t.integer "zendesk_stage_id"
    t.index ["zendesk_id"], name: "index_leads_on_zendesk_id"
  end

  create_table "runs", force: :cascade do |t|
    t.bigint "lead_id", null: false
    t.bigint "flow_id", null: false
    t.string "status"
    t.bigint "previous_action_id"
    t.bigint "next_action_id"
    t.string "scheduled_job_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["flow_id"], name: "index_runs_on_flow_id"
    t.index ["lead_id", "flow_id"], name: "index_runs_on_lead_id_and_flow_id"
    t.index ["lead_id"], name: "index_runs_on_lead_id"
    t.index ["next_action_id"], name: "index_runs_on_next_action_id"
    t.index ["previous_action_id"], name: "index_runs_on_previous_action_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "key", null: false
    t.string "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["key"], name: "index_settings_on_key", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "zendesk_stages", force: :cascade do |t|
    t.string "name", null: false
    t.string "position", null: false
    t.string "zendesk_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_zendesk_stages_on_name", unique: true
    t.index ["zendesk_id"], name: "index_zendesk_stages_on_zendesk_id", unique: true
  end

  create_table "zendesk_statuses", force: :cascade do |t|
    t.string "status", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["status"], name: "index_zendesk_statuses_on_status", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
