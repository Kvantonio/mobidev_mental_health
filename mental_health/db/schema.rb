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

ActiveRecord::Schema.define(version: 2021_12_03_142800) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "certificates", force: :cascade do |t|
    t.text "title"
    t.bigint "coaches_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["coaches_id"], name: "index_certificates_on_coaches_id"
  end

  create_table "coaches", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.integer "age"
    t.integer "gender"
    t.text "about"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "coaches_problems", id: false, force: :cascade do |t|
    t.bigint "coach_id"
    t.bigint "problem_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["coach_id"], name: "index_coaches_problems_on_coach_id"
    t.index ["problem_id"], name: "index_coaches_problems_on_problem_id"
  end

  create_table "diplomas", force: :cascade do |t|
    t.text "title"
    t.bigint "coach_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["coach_id"], name: "index_diplomas_on_coach_id"
  end

  create_table "experiences", force: :cascade do |t|
    t.text "title"
    t.bigint "coaches_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["coaches_id"], name: "index_experiences_on_coaches_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "coach_id"
    t.boolean "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["coach_id"], name: "index_invitations_on_coach_id"
    t.index ["user_id"], name: "index_invitations_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "coach_id"
    t.bigint "user_id"
    t.text "description"
    t.boolean "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["coach_id"], name: "index_notifications_on_coach_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "problems", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "problems_users", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "problem_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["problem_id"], name: "index_problems_users_on_problem_id"
    t.index ["user_id"], name: "index_problems_users_on_user_id"
  end

  create_table "raitings", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "technique_id"
    t.integer "like"
    t.integer "dislike"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["technique_id"], name: "index_raitings_on_technique_id"
    t.index ["user_id"], name: "index_raitings_on_user_id"
  end

  create_table "social_networks", force: :cascade do |t|
    t.text "title"
    t.bigint "coach_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["coach_id"], name: "index_social_networks_on_coach_id"
  end

  create_table "steps", force: :cascade do |t|
    t.text "body"
    t.integer "number"
    t.bigint "technique_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["technique_id"], name: "index_steps_on_technique_id"
  end

  create_table "techniques", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "age_range"
    t.integer "gender"
    t.string "duration"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "techniques_problems", id: false, force: :cascade do |t|
    t.bigint "technique_id"
    t.bigint "problem_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["problem_id"], name: "index_techniques_problems_on_problem_id"
    t.index ["technique_id"], name: "index_techniques_problems_on_technique_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.integer "age"
    t.integer "gender"
    t.text "about"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "certificates", "coaches", column: "coaches_id"
  add_foreign_key "diplomas", "coaches"
  add_foreign_key "experiences", "coaches", column: "coaches_id"
  add_foreign_key "notifications", "coaches"
  add_foreign_key "notifications", "users"
  add_foreign_key "social_networks", "coaches"
  add_foreign_key "steps", "techniques"
end
