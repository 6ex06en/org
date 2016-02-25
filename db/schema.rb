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

ActiveRecord::Schema.define(version: 20160225144441) do

  create_table "chats", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.string   "chat_type"
  end

  add_index "chats", ["user_id"], name: "index_chats_on_user_id"

  create_table "comments", force: :cascade do |t|
    t.integer  "task_id"
    t.string   "commenter"
    t.string   "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments", ["task_id"], name: "index_comments_on_task_id"

  create_table "news", force: :cascade do |t|
    t.boolean  "readed",     default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "user_id"
  end

  add_index "news", ["readed"], name: "index_news_on_readed"
  add_index "news", ["user_id"], name: "index_news_on_user_id"

  create_table "options", force: :cascade do |t|
    t.string   "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  add_index "options", ["user_id"], name: "index_options_on_user_id"

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "name"
    t.datetime "date_exec"
    t.integer  "manager_id"
    t.integer  "executor_id"
    t.string   "description"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "status",      default: "ready"
  end

  add_index "tasks", ["date_exec"], name: "index_tasks_on_date_exec"
  add_index "tasks", ["executor_id"], name: "index_tasks_on_executor_id"
  add_index "tasks", ["manager_id"], name: "index_tasks_on_manager_id"
  add_index "tasks", ["status"], name: "index_tasks_on_status"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.boolean  "admin",           default: false
    t.string   "auth_token"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "password_digest"
    t.integer  "organization_id"
    t.string   "privilages"
    t.boolean  "invited",         default: false
    t.integer  "join_to"
  end

  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["join_to"], name: "index_users_on_join_to"
  add_index "users", ["name"], name: "index_users_on_name"
  add_index "users", ["organization_id"], name: "index_users_on_organization_id"

  create_table "users_chats", force: :cascade do |t|
    t.integer  "chat_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "users_chats", ["chat_id"], name: "index_users_chats_on_chat_id"
  add_index "users_chats", ["user_id"], name: "index_users_chats_on_user_id"

end
