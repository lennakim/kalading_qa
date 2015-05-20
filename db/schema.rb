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

ActiveRecord::Schema.define(version: 20150520025614) do

  create_table "answers", force: :cascade do |t|
    t.integer  "question_id",  limit: 4
    t.string   "replier_id",   limit: 255
    t.string   "replier_type", limit: 255
    t.text     "content",      limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "adopted_at"
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["replier_id"], name: "index_answers_on_replier_id", using: :btree

  create_table "auto_brands", force: :cascade do |t|
    t.string   "name",        limit: 255, null: false
    t.string   "internal_id", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "auto_brands", ["internal_id"], name: "index_auto_brands_on_internal_id", using: :btree

  create_table "auto_models", force: :cascade do |t|
    t.string   "name",                   limit: 255, null: false
    t.string   "internal_id",            limit: 255, null: false
    t.string   "auto_brand_internal_id", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "auto_models", ["auto_brand_internal_id"], name: "index_auto_models_on_auto_brand_internal_id", using: :btree
  add_index "auto_models", ["internal_id"], name: "index_auto_models_on_internal_id", using: :btree

  create_table "auto_submodels", force: :cascade do |t|
    t.string   "name",                   limit: 255, null: false
    t.string   "full_name",              limit: 255, null: false
    t.string   "internal_id",            limit: 255, null: false
    t.string   "auto_model_internal_id", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "auto_brand_internal_id", limit: 255, null: false
  end

  add_index "auto_submodels", ["auto_brand_internal_id"], name: "index_auto_submodels_on_auto_brand_internal_id", using: :btree
  add_index "auto_submodels", ["auto_model_internal_id"], name: "index_auto_submodels_on_auto_model_internal_id", using: :btree
  add_index "auto_submodels", ["internal_id"], name: "index_auto_submodels_on_internal_id", using: :btree

  create_table "question_assignments", force: :cascade do |t|
    t.integer  "question_id",      limit: 4,   null: false
    t.string   "user_internal_id", limit: 255, null: false
    t.string   "user_role",        limit: 255, null: false
    t.string   "state",            limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "expire_at"
    t.datetime "answered_at"
    t.string   "question_state",   limit: 255, null: false
  end

  add_index "question_assignments", ["question_id", "state"], name: "index_question_assignments_on_question_id_and_state", using: :btree
  add_index "question_assignments", ["state", "expire_at"], name: "index_question_assignments_on_state_and_expire_at", using: :btree
  add_index "question_assignments", ["user_internal_id", "state", "updated_at"], name: "idx_q_assignments_on_internal_id_and_state_and_updated_at", using: :btree

  create_table "question_bases", force: :cascade do |t|
    t.string   "auto_brand_internal_id",    limit: 255
    t.string   "auto_model_internal_id",    limit: 255
    t.string   "auto_submodel_internal_id", limit: 255
    t.text     "question_content",          limit: 65535
    t.text     "answer_content",            limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "question_images",           limit: 65535
  end

  create_table "questions", force: :cascade do |t|
    t.string   "auto_brand_internal_id",    limit: 255
    t.string   "auto_model_internal_id",    limit: 255
    t.string   "auto_submodel_internal_id", limit: 255
    t.integer  "customer_id",               limit: 4
    t.text     "content",                   limit: 65535
    t.string   "state",                     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "images",                    limit: 65535
    t.datetime "expire_at"
    t.integer  "engineer_race_count",       limit: 4,     default: 0
  end

  add_index "questions", ["customer_id"], name: "index_questions_on_customer_id", using: :btree
  add_index "questions", ["state", "created_at"], name: "index_questions_on_state_and_created_at", using: :btree
  add_index "questions", ["state", "expire_at"], name: "index_questions_on_state_and_expire_at", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string "name", limit: 255, null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id",     limit: 4
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count", limit: 4,   default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "user_roles", force: :cascade do |t|
    t.integer  "user_id",    limit: 4, null: false
    t.integer  "role_id",    limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_roles", ["role_id"], name: "index_user_roles_on_role_id", using: :btree
  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id", using: :btree

  create_table "user_tokens", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "token",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "phone_num",           limit: 255, default: "", null: false
    t.string   "encrypted_password",  limit: 255, default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",  limit: 255
    t.string   "last_sign_in_ip",     limit: 255
    t.integer  "failed_attempts",     limit: 4,   default: 0,  null: false
    t.datetime "locked_at"
    t.string   "name",                limit: 255
    t.string   "name_pinyin",         limit: 255, default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "internal_id",         limit: 255,              null: false
    t.string   "city_internal_id",    limit: 255
  end

  add_index "users", ["internal_id"], name: "index_users_on_internal_id", using: :btree
  add_index "users", ["phone_num"], name: "index_users_on_phone_num", unique: true, using: :btree

end
