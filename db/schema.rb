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

ActiveRecord::Schema.define(version: 2021_07_13_193059) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "basic_choices", force: :cascade do |t|
    t.json "choices", null: false
    t.integer "correct_number", default: 0, null: false
  end

  create_table "drill_likes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "drill_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["drill_id"], name: "index_drill_likes_on_drill_id"
    t.index ["user_id", "drill_id"], name: "index_drill_likes_on_user_id_and_drill_id", unique: true
    t.index ["user_id"], name: "index_drill_likes_on_user_id"
  end

  create_table "drill_user_results", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "drill_id", null: false
    t.integer "number_of_problem_mastered", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["drill_id"], name: "index_drill_user_results_on_drill_id"
    t.index ["user_id", "drill_id"], name: "index_drill_user_results_on_user_id_and_drill_id", unique: true
    t.index ["user_id"], name: "index_drill_user_results_on_user_id"
  end

  create_table "drills", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", default: "", null: false
    t.string "guide", default: "", null: false
    t.integer "state", default: 0, null: false
    t.integer "number_of_views", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "impressions_count", default: 0
    t.integer "problem_size", default: 0, null: false
    t.index ["user_id", "title"], name: "index_drills_on_user_id_and_title", unique: true
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

  create_table "problem_user_results", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "problem_id"
    t.integer "number_of_views", default: 0
    t.integer "number_of_submissions", default: 0
    t.integer "current_streak", default: 0
    t.integer "number_of_correct_answers", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["problem_id"], name: "index_problem_user_results_on_problem_id"
    t.index ["user_id", "problem_id"], name: "index_problem_user_results_on_user_id_and_problem_id", unique: true
    t.index ["user_id"], name: "index_problem_user_results_on_user_id"
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
    t.integer "number_of_viewers", default: 0, null: false
    t.integer "number_of_submitters", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["drill_id"], name: "index_problems_on_drill_id"
    t.index ["user_id"], name: "index_problems_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "nickname"
    t.string "login_name"
    t.string "icon"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["login_name"], name: "index_users_on_login_name"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "drill_likes", "drills"
  add_foreign_key "drill_likes", "users"
  add_foreign_key "drill_user_results", "drills"
  add_foreign_key "drill_user_results", "users"
  add_foreign_key "drills", "users"
  add_foreign_key "problem_user_results", "problems"
  add_foreign_key "problem_user_results", "users"
  add_foreign_key "problems", "drills"
  add_foreign_key "problems", "users"
end
