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

ActiveRecord::Schema[7.1].define(version: 2024_01_06_175513) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "product_id", null: false
    t.datetime "service_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_bookings_on_product_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "shop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rating", default: 0, null: false
    t.index ["shop_id"], name: "index_comments_on_shop_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "like_shops", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "shop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_like_shops_on_shop_id"
    t.index ["user_id"], name: "index_like_shops_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "status", default: "pending"
    t.datetime "service_date"
    t.string "serial"
    t.decimal "price"
    t.integer "quantitiy", default: 1
    t.integer "service_min"
    t.string "booked_name"
    t.string "booked_email"
    t.bigint "user_id", null: false
    t.bigint "shop_id", null: false
    t.bigint "product_id", null: false
    t.datetime "deleted_at"
    t.datetime "cancelled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "payment_date"
    t.string "payment_type"
    t.string "payment_type_charge_fee"
    t.string "return_code"
    t.string "return_msg"
    t.string "staff"
    t.string "trade_no"
    t.index ["cancelled_at"], name: "index_orders_on_cancelled_at"
    t.index ["product_id"], name: "index_orders_on_product_id"
    t.index ["serial"], name: "index_orders_on_serial"
    t.index ["service_date"], name: "index_orders_on_service_date"
    t.index ["shop_id"], name: "index_orders_on_shop_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.decimal "price"
    t.boolean "onsale", default: false
    t.datetime "deleted_at"
    t.integer "position"
    t.datetime "publish_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "service_min"
    t.bigint "shop_id"
    t.index ["deleted_at"], name: "index_products_on_deleted_at"
    t.index ["shop_id"], name: "index_products_on_shop_id"
  end

  create_table "service_times", force: :cascade do |t|
    t.string "day_of_week"
    t.time "open_time"
    t.time "close_time"
    t.time "lunch_start"
    t.time "lunch_end"
    t.boolean "off_day", default: false
    t.bigint "shop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_service_times_on_shop_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "title"
    t.string "tel"
    t.text "description"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "city"
    t.string "district"
    t.text "street"
    t.bigint "user_id"
    t.string "contact"
    t.string "contactphone"
    t.string "status"
    t.index ["deleted_at"], name: "index_shops_on_deleted_at"
    t.index ["user_id"], name: "index_shops_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "provider"
    t.string "uid"

    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookings", "products"
  add_foreign_key "bookings", "users"
  add_foreign_key "comments", "shops"
  add_foreign_key "comments", "users"
  add_foreign_key "like_shops", "shops"
  add_foreign_key "like_shops", "users"
  add_foreign_key "orders", "products"
  add_foreign_key "orders", "shops"
  add_foreign_key "orders", "users"
  add_foreign_key "products", "shops"
  add_foreign_key "service_times", "shops"
  add_foreign_key "shops", "users"
end
