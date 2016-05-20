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

ActiveRecord::Schema.define(version: 20160510220100) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.integer  "client_id",  null: false
    t.string   "uid",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_accounts_on_client_id", using: :btree
    t.index ["uid"], name: "index_accounts_on_uid", using: :btree
  end

  create_table "assignments", force: :cascade do |t|
    t.string   "title",      null: false
    t.datetime "deadline"
    t.text     "content"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_assignments_on_course_id", using: :btree
  end

  create_table "clients", force: :cascade do |t|
    t.string   "name",                              null: false
    t.string   "email",                             null: false
    t.string   "password_digest"
    t.string   "cid",                               null: false
    t.string   "secret",                            null: false
    t.string   "scopes",               default: "", null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.index ["cid"], name: "index_clients_on_cid", unique: true, using: :btree
    t.index ["email"], name: "index_clients_on_email", unique: true, using: :btree
    t.index ["name"], name: "index_clients_on_name", unique: true, using: :btree
  end

  create_table "courses", force: :cascade do |t|
    t.string   "name",                   null: false
    t.integer  "status",     default: 0
    t.integer  "client_id",              null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["client_id"], name: "index_courses_on_client_id", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",          null: false
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
    t.index ["name"], name: "index_roles_on_name", using: :btree
  end

  create_table "solutions", force: :cascade do |t|
    t.integer  "assignment_id"
    t.integer  "account_id"
    t.text     "content"
    t.integer  "grade",         default: 0
    t.datetime "submit_at"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["account_id"], name: "index_solutions_on_account_id", using: :btree
    t.index ["assignment_id"], name: "index_solutions_on_assignment_id", using: :btree
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.string  "user_type"
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree
  end

end
