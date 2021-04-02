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

ActiveRecord::Schema.define(version: 2021_04_01_213950) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "appearances", force: :cascade do |t|
    t.bigint "title_id", null: false
    t.bigint "participant_id", null: false
    t.integer "role"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["participant_id"], name: "index_appearances_on_participant_id"
    t.index ["role", "participant_id", "title_id"], name: "index_appearances_on_role_and_participant_id_and_title_id", unique: true
    t.index ["role"], name: "index_appearances_on_role"
    t.index ["title_id"], name: "index_appearances_on_title_id"
  end

  create_table "participants", force: :cascade do |t|
    t.string "full_name"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "actor", default: false, null: false
    t.boolean "director", default: false, null: false
    t.index ["actor"], name: "index_participants_on_actor"
    t.index ["director"], name: "index_participants_on_director"
    t.index ["first_name"], name: "index_participants_on_first_name"
    t.index ["full_name"], name: "index_participants_on_full_name", unique: true
    t.index ["last_name"], name: "index_participants_on_last_name"
  end

  create_table "searchjoy_searches", force: :cascade do |t|
    t.bigint "user_id"
    t.string "search_type"
    t.string "query"
    t.string "normalized_query"
    t.integer "results_count"
    t.datetime "created_at"
    t.string "convertable_type"
    t.bigint "convertable_id"
    t.datetime "converted_at"
    t.index ["convertable_type", "convertable_id"], name: "index_searchjoy_searches_on_convertable"
    t.index ["created_at"], name: "index_searchjoy_searches_on_created_at"
    t.index ["search_type", "created_at"], name: "index_searchjoy_searches_on_search_type_and_created_at"
    t.index ["search_type", "normalized_query", "created_at"], name: "index_searchjoy_searches_on_search_type_query"
    t.index ["user_id"], name: "index_searchjoy_searches_on_user_id"
  end

  create_table "titles", force: :cascade do |t|
    t.string "title"
    t.string "type"
    t.integer "year"
    t.string "image_url"
    t.string "color"
    t.decimal "score"
    t.integer "rating"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["title"], name: "index_titles_on_title"
    t.index ["type"], name: "index_titles_on_type"
    t.index ["year"], name: "index_titles_on_year"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "appearances", "participants"
  add_foreign_key "appearances", "titles"
end
