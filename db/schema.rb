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

ActiveRecord::Schema.define(version: 20180831052725) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "info_predio_detalles", force: :cascade do |t|
    t.bigint "material_id"
    t.integer "cantidad"
    t.bigint "info_predio_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["info_predio_id"], name: "index_info_predio_detalles_on_info_predio_id"
    t.index ["material_id"], name: "index_info_predio_detalles_on_material_id"
  end

  create_table "info_predio_workers", force: :cascade do |t|
    t.bigint "worker_id"
    t.decimal "precio"
    t.bigint "info_predio_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["info_predio_id"], name: "index_info_predio_workers_on_info_predio_id"
    t.index ["worker_id"], name: "index_info_predio_workers_on_worker_id"
  end

  create_table "info_predios", force: :cascade do |t|
    t.decimal "fumigada"
    t.decimal "pago_trabaja"
    t.integer "conteo_racimos"
    t.string "color_cinta"
    t.integer "semana"
    t.date "fecha_embarque"
    t.decimal "precio"
    t.decimal "venta"
    t.bigint "predio_id"
    t.bigint "user_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "nutriente"
    t.decimal "ratio"
    t.index ["predio_id"], name: "index_info_predios_on_predio_id"
    t.index ["user_id"], name: "index_info_predios_on_user_id"
  end

  create_table "materiales", force: :cascade do |t|
    t.string "name"
    t.integer "price"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "materials", force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "otros_gastos", force: :cascade do |t|
    t.string "nombre"
    t.decimal "precio"
    t.bigint "info_predio_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["info_predio_id"], name: "index_otros_gastos_on_info_predio_id"
  end

  create_table "predios", force: :cascade do |t|
    t.string "name"
    t.integer "no_hectareas"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "requests", force: :cascade do |t|
    t.bigint "user_id"
    t.string "predio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.boolean "admin", default: false
    t.boolean "email_confirmed", default: false
    t.string "confirm_token"
    t.string "reset_token"
    t.datetime "reset_sent_at"
    t.string "token_chart"
  end

  create_table "vuelos", force: :cascade do |t|
    t.bigint "user_id"
    t.string "predio"
    t.string "aplicacion"
    t.string "piloto"
    t.integer "precio_vuelo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_vuelos_on_user_id"
  end

  create_table "worker_types", force: :cascade do |t|
    t.string "name"
  end

  create_table "workers", force: :cascade do |t|
    t.string "name"
    t.string "last_name"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "worker_type_id"
  end

  add_foreign_key "requests", "users"
  add_foreign_key "vuelos", "users"
end
