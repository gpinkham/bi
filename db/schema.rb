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

ActiveRecord::Schema.define(version: 20140610000000) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "kpi_results", force: true do |t|
    t.date     "date"
    t.float    "today"
    t.float    "t7days"
    t.float    "t30days"
    t.float    "today_pct_change"
    t.float    "t7days_pct_change"
    t.float    "t30days_pct_change"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "ytd"
    t.integer  "kpi_id"
    t.float    "qtd"
  end

  add_index "kpi_results", ["date"], name: "index_daily_kpis_on_date", using: :btree
  add_index "kpi_results", ["kpi_id", "date"], name: "index_kpi_results_on_kpi_id_and_date", using: :btree
  add_index "kpi_results", ["kpi_id"], name: "index_daily_kpis_on_kpi_id", using: :btree

  create_table "kpis", force: true do |t|
    t.string   "name",                       null: false
    t.text     "query",                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",      default: true, null: false
    t.string   "data_source"
  end

  create_table "questions", force: true do |t|
    t.string   "name",         null: false
    t.text     "description",  null: false
    t.text     "question_sql", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "data_source"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string "name"
  end

  create_table "users", force: true do |t|
    t.string   "name",          null: false
    t.integer  "omniauth_id",   null: false
    t.string   "email_address"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "users", ["omniauth_id"], name: "index_users_on_omniauth_id", unique: true, using: :btree

end
