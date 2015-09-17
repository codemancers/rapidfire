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

ActiveRecord::Schema.define(version: 20150917095656) do

  create_table "rapidfire_answers", force: :cascade do |t|
    t.integer  "attempt_id"
    t.integer  "question_id"
    t.text     "answer_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rapidfire_answers", ["attempt_id"], name: "index_rapidfire_answers_on_attempt_id"
  add_index "rapidfire_answers", ["question_id"], name: "index_rapidfire_answers_on_question_id"

  create_table "rapidfire_attempts", force: :cascade do |t|
    t.integer  "survey_id"
    t.integer  "user_id"
    t.string   "user_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rapidfire_attempts", ["survey_id"], name: "index_rapidfire_attempts_on_survey_id"
  add_index "rapidfire_attempts", ["user_type", "user_id"], name: "index_rapidfire_attempts_on_user_type_and_user_id"

  create_table "rapidfire_questions", force: :cascade do |t|
    t.integer  "survey_id"
    t.string   "type"
    t.string   "question_text"
    t.integer  "position"
    t.text     "answer_options"
    t.text     "validation_rules"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rapidfire_questions", ["survey_id"], name: "index_rapidfire_questions_on_survey_id"

  create_table "rapidfire_surveys", force: :cascade do |t|
    t.integer  "tenant_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rapidfire_surveys", ["tenant_id"], name: "index_rapidfire_surveys_on_tenant_id"

end
