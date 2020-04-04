# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_04_181315) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "group_messages", force: :cascade do |t|
    t.bigint "group_id"
    t.text "message"
    t.bigint "owner_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_group_messages_on_group_id"
    t.index ["owner_id"], name: "index_group_messages_on_owner_id"
  end

  create_table "group_user_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "group_id"
    t.bigint "owner_id"
    t.integer "type_request"
    t.integer "status"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_group_user_requests_on_group_id"
    t.index ["owner_id"], name: "index_group_user_requests_on_owner_id"
    t.index ["user_id"], name: "index_group_user_requests_on_user_id"
  end

  create_table "group_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "group_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_group_users_on_group_id"
    t.index ["user_id"], name: "index_group_users_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "photo"
    t.bigint "owner_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owner_id"], name: "index_groups_on_owner_id"
  end

  create_table "personal_infos", force: :cascade do |t|
    t.string "firstname", limit: 100
    t.string "secondname", limit: 100
    t.string "lastname", limit: 100
    t.integer "gender", limit: 2
    t.bigint "dob"
    t.text "photo"
    t.text "country"
    t.text "city"
    t.text "address"
    t.text "hobbies"
    t.datetime "created_at", precision: 6, default: -> { "now()" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "now()" }, null: false
  end

  create_table "relationship_requests", force: :cascade do |t|
    t.bigint "user1_id"
    t.bigint "user2_id"
    t.bigint "type1_id"
    t.bigint "type2_id"
    t.integer "status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["type1_id"], name: "index_relationship_requests_on_type1_id"
    t.index ["type2_id"], name: "index_relationship_requests_on_type2_id"
    t.index ["user1_id"], name: "index_relationship_requests_on_user1_id"
    t.index ["user2_id"], name: "index_relationship_requests_on_user2_id"
  end

  create_table "relationship_types", force: :cascade do |t|
    t.text "name"
    t.integer "ratio"
    t.text "female"
    t.text "male"
    t.text "prefix"
  end

  create_table "relationships", id: false, force: :cascade do |t|
    t.bigint "user1_id"
    t.bigint "user2_id"
    t.bigint "type1_id"
    t.bigint "type2_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["type1_id"], name: "index_relationships_on_type1_id"
    t.index ["type2_id"], name: "index_relationships_on_type2_id"
    t.index ["user1_id"], name: "index_relationships_on_user1_id"
    t.index ["user2_id"], name: "index_relationships_on_user2_id"
  end

  create_table "studies", force: :cascade do |t|
    t.text "name"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_studies_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "is_user", limit: 2
    t.string "email"
    t.bigint "tel"
    t.text "token"
    t.datetime "time_token"
    t.text "code"
    t.datetime "time_code"
    t.bigint "personal_info_id"
    t.datetime "created_at", precision: 6, default: -> { "now()" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "now()" }, null: false
    t.bigint "owner_id"
    t.integer "is_reg", limit: 2, default: 0
    t.integer "code_type"
    t.string "new_value"
    t.index ["owner_id"], name: "index_users_on_owner_id"
    t.index ["personal_info_id"], name: "index_users_on_personal_info_id"
  end

  create_table "works", force: :cascade do |t|
    t.text "name"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_works_on_user_id"
  end

end
