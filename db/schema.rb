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

ActiveRecord::Schema.define(version: 2021_03_23_224105) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "basic_choices", force: :cascade do |t|
    t.json "choices", null: false
    t.integer "correct_number", default: 0, null: false
  end

  create_table "drills", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", default: "無題", null: false
    t.string "guide", default: "", null: false
    t.integer "state", default: 0, null: false
    t.integer "number_of_views", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "impressions_count", default: 0
    t.index ["user_id"], name: "index_drills_on_user_id"
  end

  create_table "impressions", force: :cascade do |t|
    t.string "impressionable_type"
    t.integer "impressionable_id"
    t.integer "user_id"
    t.string "controller_name"
    t.string "action_name"
    t.string "view_name"
    t.string "request_hash"
    t.string "ip_address"
    t.string "session_hash"
    t.text "message"
    t.text "referrer"
    t.text "params"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index"
    t.index ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index"
    t.index ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index"
    t.index ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index"
    t.index ["impressionable_type", "impressionable_id", "params"], name: "poly_params_request_index"
    t.index ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index"
    t.index ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index"
    t.index ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index"
    t.index ["user_id"], name: "index_impressions_on_user_id"
  end

  create_table "problems", force: :cascade do |t|
    t.bigint "drill_id", null: false
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.string "statement", null: false
    t.integer "format", null: false
    t.json "choices", null: false
    t.integer "correct_option", null: false
    t.text "explanation", null: false
    t.integer "impressions_count", default: 0, null: false
    t.integer "number_of_views", default: 0, null: false
    t.integer "number_of_submissions", default: 0, null: false
    t.integer "number_of_correct_answers", default: 0, null: false
    t.integer "correct_answer_rate", limit: 2
    t.integer "number_of_viewers", default: 0, null: false
    t.integer "number_of_submitters", default: 0, null: false
    t.integer "number_of_one_shot_answerers", default: 0, null: false
    t.integer "number_of_last_shot_answerers", default: 0, null: false
    t.integer "correct_people_rate", limit: 2
    t.boolean "open", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["drill_id"], name: "index_problems_on_drill_id"
    t.index ["user_id"], name: "index_problems_on_user_id"
  end

  create_table "user_problem_relations", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "problem_id"
    t.integer "number_of_views", default: 0
    t.integer "number_of_submissions", default: 0
    t.integer "number_of_correct_answers", default: 0
    t.integer "correct_answer_rate", limit: 2, default: 0
    t.float "average_time"
    t.float "first_time"
    t.float "fastest_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["problem_id"], name: "index_user_problem_relations_on_problem_id"
    t.index ["user_id", "problem_id"], name: "index_user_problem_relations_on_user_id_and_problem_id", unique: true
    t.index ["user_id"], name: "index_user_problem_relations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "nickname"
    t.string "login_name"
    t.string "icon"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["login_name"], name: "index_users_on_login_name"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "drills", "users"
  add_foreign_key "problems", "drills"
  add_foreign_key "problems", "users"
  add_foreign_key "user_problem_relations", "problems"
  add_foreign_key "user_problem_relations", "users"
end
