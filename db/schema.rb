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

ActiveRecord::Schema[8.1].define(version: 2026_01_16_205315) do
  create_table "clients", force: :cascade do |t|
    t.string "address"
    t.string "city"
    t.string "cpf"
    t.datetime "created_at", null: false
    t.string "name"
    t.string "neighborhood"
    t.string "phone"
    t.string "state"
    t.datetime "updated_at", null: false
    t.string "zipcode"
  end

  create_table "products", force: :cascade do |t|
    t.boolean "active", default: true
    t.string "barcode"
    t.decimal "cost_price"
    t.datetime "created_at", null: false
    t.string "name"
    t.decimal "price"
    t.decimal "price_cost"
    t.integer "stock_quantity"
    t.datetime "updated_at", null: false
  end

  create_table "sale_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "price"
    t.integer "product_id", null: false
    t.integer "quantity"
    t.integer "sale_id", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_sale_items_on_product_id"
    t.index ["sale_id"], name: "index_sale_items_on_sale_id"
  end

  create_table "sales", force: :cascade do |t|
    t.integer "client_id"
    t.datetime "created_at", null: false
    t.decimal "discount"
    t.string "payment_method"
    t.decimal "surcharge"
    t.decimal "total"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["client_id"], name: "index_sales_on_client_id"
    t.index ["user_id"], name: "index_sales_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: ""
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "role"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "sale_items", "products"
  add_foreign_key "sale_items", "sales"
  add_foreign_key "sales", "clients"
  add_foreign_key "sales", "users"
end
