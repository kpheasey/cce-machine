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

ActiveRecord::Schema.define(version: 20140306141805) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "companies", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "currencies", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "currencies", ["code"], name: "index_currencies_on_code", unique: true, using: :btree

  create_table "exchange_accounts", force: true do |t|
    t.string   "username"
    t.string   "key"
    t.string   "secret"
    t.integer  "exchange_id"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exchange_markets", force: true do |t|
    t.integer  "market_id"
    t.integer  "exchange_id"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exchanges", force: true do |t|
    t.string  "type"
    t.string  "name"
    t.string  "code"
    t.string  "permalink"
    t.string  "slug"
    t.boolean "is_active",          default: true
    t.boolean "is_default",         default: false
    t.integer "exchange_market_id"
  end

  add_index "exchanges", ["permalink"], name: "index_exchanges_on_permalink", unique: true, using: :btree
  add_index "exchanges", ["slug"], name: "index_exchanges_on_slug", unique: true, using: :btree

  create_table "fees", force: true do |t|
    t.decimal  "min"
    t.decimal  "max"
    t.decimal  "fee"
    t.decimal  "discount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "exchange_market_id"
  end

  add_index "fees", ["exchange_market_id"], name: "index_fees_on_exchange_market_id", using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "markets", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "source_id"
    t.integer  "target_id"
    t.string   "permalink"
    t.string   "slug"
    t.boolean  "is_default", default: false
    t.boolean  "is_active",  default: true
  end

  add_index "markets", ["permalink"], name: "index_markets_on_permalink", unique: true, using: :btree
  add_index "markets", ["slug"], name: "index_markets_on_slug", unique: true, using: :btree
  add_index "markets", ["source_id", "target_id"], name: "index_markets_on_source_id_and_target_id", unique: true, using: :btree

  create_table "orders", force: true do |t|
    t.string   "type"
    t.integer  "market_id"
    t.integer  "exchange_id"
    t.decimal  "price"
    t.decimal  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["exchange_id"], name: "index_orders_on_exchange_id", using: :btree
  add_index "orders", ["market_id", "exchange_id"], name: "index_orders_on_market_id_and_exchange_id", using: :btree

  create_table "tickers", force: true do |t|
    t.string   "type"
    t.integer  "exchange_id"
    t.integer  "market_id"
    t.decimal  "high"
    t.decimal  "open"
    t.decimal  "close"
    t.decimal  "low"
    t.decimal  "volume"
    t.integer  "count"
    t.datetime "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tickers", ["type", "exchange_id", "market_id"], name: "index_tickers_on_type_and_exchange_id_and_market_id", using: :btree

  create_table "trades", force: true do |t|
    t.integer  "market_id"
    t.integer  "exchange_id"
    t.decimal  "price"
    t.decimal  "amount"
    t.integer  "exchange_trade_id", limit: 8
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trades", ["exchange_id"], name: "index_trades_on_exchange_id", using: :btree
  add_index "trades", ["market_id", "exchange_id"], name: "index_trades_on_market_id_and_exchange_id", using: :btree

  create_table "user_wallets", force: true do |t|
    t.integer  "user_id"
    t.integer  "wallet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "wallets", force: true do |t|
    t.string   "type"
    t.integer  "company_id"
    t.string   "address"
    t.integer  "currency_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
