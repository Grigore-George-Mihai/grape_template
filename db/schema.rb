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

ActiveRecord::Schema[7.2].define(version: 2024_10_23_111240) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pghero_query_stats", force: :cascade do |t|
    t.text "database"
    t.text "user"
    t.text "query"
    t.bigint "query_hash"
    t.float "total_time"
    t.bigint "calls"
    t.datetime "captured_at", precision: nil
    t.index ["database", "captured_at"], name: "index_pghero_query_stats_on_database_and_captured_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "password_digest"
    t.string "jti", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.index "lower((email)::text)", name: "index_users_on_LOWER_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
  end
end
