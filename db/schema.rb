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

ActiveRecord::Schema.define(version: 2019_02_08_210723) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "administrators", force: :cascade do |t|
    t.string "first_name"
    t.string "second_name"
    t.integer "telegram_id"
    t.integer "state"
    t.integer "mode"
    t.boolean "logged_in"
    t.string "work_with_product"
    t.boolean "custom_keyboard", default: false
  end

  create_table "items", force: :cascade do |t|
    t.integer "count"
    t.integer "product_id"
    t.integer "price"
  end

  create_table "orders", force: :cascade do |t|
    t.text "delivery_info"
    t.integer "price"
    t.integer "discount"
    t.integer "status"
    t.bigint "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_orders_on_item_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "product_id"
    t.integer "cost"
    t.integer "price"
    t.string "landscape"
    t.string "images", default: [], array: true
    t.integer "in_stock"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "second_name"
    t.integer "telegram_id"
    t.string "telegram_username"
    t.string "city"
    t.integer "phone_number"
    t.integer "post_type"
    t.integer "post_office"
    t.integer "state"
    t.bigint "order_id"
    t.index ["order_id"], name: "index_users_on_order_id"
  end

end
