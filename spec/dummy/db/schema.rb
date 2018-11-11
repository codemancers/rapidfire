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

ActiveRecord::Schema.define(version: 20170701191411) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "rapidfire_answers", force: :cascade do |t|
    t.bigint "attempt_id"
    t.bigint "question_id"
    t.text "answer_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attempt_id"], name: "index_rapidfire_answers_on_attempt_id"
    t.index ["question_id"], name: "index_rapidfire_answers_on_question_id"
  end

  create_table "rapidfire_attempts", force: :cascade do |t|
    t.bigint "survey_id"
    t.string "user_type"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_rapidfire_attempts_on_survey_id"
    t.index ["user_type", "user_id"], name: "index_rapidfire_attempts_on_user_type_and_user_id"
  end

  create_table "rapidfire_questions", force: :cascade do |t|
    t.bigint "survey_id"
    t.string "type"
    t.string "question_text"
    t.string "default_text"
    t.string "placeholder"
    t.integer "position"
    t.text "answer_options"
    t.text "validation_rules"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_rapidfire_questions_on_survey_id"
  end

  create_table "rapidfire_surveys", force: :cascade do |t|
    t.string   "name"
    t.text     "introduction"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "after_survey_content"
  end

end
