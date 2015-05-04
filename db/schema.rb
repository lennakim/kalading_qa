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

ActiveRecord::Schema.define(version: 20150504054231) do

  create_table "answers", force: :cascade do |t|
    t.integer  "question_id",  limit: 4
    t.string   "replier_id",   limit: 255
    t.string   "replier_type", limit: 255
    t.text     "content",      limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["replier_id"], name: "index_answers_on_replier_id", using: :btree

  create_table "question_bases", force: :cascade do |t|
    t.string   "auto_brand_id",    limit: 255
    t.string   "auto_model_id",    limit: 255
    t.string   "auto_submodel_id", limit: 255
    t.text     "question_content", limit: 65535
    t.text     "answer_content",   limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "question_bases_tags", id: false, force: :cascade do |t|
    t.integer "question_base_id", limit: 4
    t.integer "tag_id",           limit: 4
  end

  add_index "question_bases_tags", ["question_base_id"], name: "index_question_bases_tags_on_question_base_id", using: :btree
  add_index "question_bases_tags", ["tag_id"], name: "index_question_bases_tags_on_tag_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.string   "auto_brand_id",    limit: 255
    t.string   "auto_model_id",    limit: 255
    t.string   "auto_submodel_id", limit: 255
    t.integer  "customer_id",      limit: 4
    t.text     "content",          limit: 65535
    t.string   "status",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["customer_id"], name: "index_questions_on_customer_id", using: :btree
  add_index "questions", ["status", "created_at"], name: "index_questions_on_status_and_created_at", using: :btree

  create_table "questions_tags", id: false, force: :cascade do |t|
    t.integer "question_id", limit: 4
    t.integer "tag_id",      limit: 4
  end

  add_index "questions_tags", ["question_id"], name: "index_questions_tags_on_question_id", using: :btree
  add_index "questions_tags", ["tag_id"], name: "index_questions_tags_on_tag_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
