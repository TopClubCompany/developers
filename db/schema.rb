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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121027083010) do

  create_table "asset_translations", :force => true do |t|
    t.integer  "asset_id"
    t.string   "locale"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "asset_translations", ["asset_id"], :name => "index_asset_translations_on_asset_id"
  add_index "asset_translations", ["locale"], :name => "index_asset_translations_on_locale"

  create_table "assets", :force => true do |t|
    t.string   "data_file_name",                                     :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id",                                       :null => false
    t.string   "assetable_type",    :limit => 25,                    :null => false
    t.string   "type",              :limit => 25
    t.string   "guid",              :limit => 10
    t.integer  "locale",            :limit => 1,  :default => 0
    t.integer  "user_id"
    t.integer  "sort_order",                      :default => 0
    t.boolean  "is_main",                         :default => false
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
  end

  add_index "assets", ["assetable_type", "assetable_id"], :name => "index_assets_on_assetable_type_and_assetable_id"
  add_index "assets", ["assetable_type", "type", "assetable_id"], :name => "index_assets_on_assetable_type_and_type_and_assetable_id"
  add_index "assets", ["user_id"], :name => "index_assets_on_user_id"

  create_table "categories", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "user_id"
    t.boolean  "is_visible", :default => true, :null => false
    t.integer  "parent_id"
    t.integer  "lft",        :default => 0
    t.integer  "rgt",        :default => 0
    t.integer  "depth",      :default => 0
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "categories", ["lft", "rgt"], :name => "index_categories_on_lft_and_rgt"
  add_index "categories", ["parent_id"], :name => "index_categories_on_parent_id"
  add_index "categories", ["slug"], :name => "index_categories_on_slug", :unique => true
  add_index "categories", ["user_id"], :name => "index_categories_on_user_id"

  create_table "category_translations", :force => true do |t|
    t.integer  "category_id"
    t.string   "locale"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "category_translations", ["category_id"], :name => "index_category_translations_on_category_id"
  add_index "category_translations", ["locale"], :name => "index_category_translations_on_locale"

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "events", :force => true do |t|
    t.datetime "start_at"
    t.string   "picture"
    t.string   "kind"
    t.string   "title"
    t.integer  "place_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "events", ["place_id"], :name => "index_events_on_place_id"

  create_table "header_translations", :force => true do |t|
    t.integer  "header_id"
    t.string   "locale"
    t.string   "title"
    t.string   "keywords"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "header_translations", ["header_id"], :name => "index_header_translations_on_header_id"
  add_index "header_translations", ["locale"], :name => "index_header_translations_on_locale"

  create_table "headers", :force => true do |t|
    t.string   "headerable_type", :limit => 30, :null => false
    t.integer  "headerable_id",                 :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "headers", ["headerable_type", "headerable_id"], :name => "fk_headerable", :unique => true

  create_table "kitchen_translations", :force => true do |t|
    t.integer  "kitchen_id"
    t.string   "locale"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "kitchen_translations", ["kitchen_id"], :name => "index_kitchen_translations_on_kitchen_id"
  add_index "kitchen_translations", ["locale"], :name => "index_kitchen_translations_on_locale"

  create_table "kitchens", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "user_id"
    t.boolean  "is_visible", :default => true, :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "kitchens", ["slug"], :name => "index_kitchens_on_slug", :unique => true
  add_index "kitchens", ["user_id"], :name => "index_kitchens_on_user_id"

  create_table "notes", :force => true do |t|
    t.integer  "place_id"
    t.string   "picture"
    t.string   "title"
    t.string   "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "place_categories", :force => true do |t|
    t.integer  "category_id"
    t.integer  "place_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "place_categories", ["category_id"], :name => "index_place_categories_on_category_id"
  add_index "place_categories", ["place_id"], :name => "index_place_categories_on_place_id"

  create_table "place_translations", :force => true do |t|
    t.integer  "place_id"
    t.string   "locale"
    t.string   "name"
    t.text     "description"
    t.text     "address"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "place_translations", ["locale"], :name => "index_place_translations_on_locale"
  add_index "place_translations", ["place_id"], :name => "index_place_translations_on_place_id"

  create_table "places", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "user_id"
    t.boolean  "is_visible", :default => true, :null => false
    t.float    "lat"
    t.float    "lng"
    t.float    "zoom"
    t.string   "phone"
    t.string   "url"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "kitchen_id"
    t.integer  "avgbill"
    t.string   "picture"
  end

  add_index "places", ["slug"], :name => "index_places_on_slug", :unique => true
  add_index "places", ["user_id"], :name => "index_places_on_user_id"

  create_table "places_selections", :id => false, :force => true do |t|
    t.integer "place_id"
    t.integer "selection_id"
  end

  create_table "price_ranges", :force => true do |t|
    t.float    "min_price"
    t.float    "max_price"
    t.float    "avg_price"
    t.integer  "place_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "reviews", :force => true do |t|
    t.integer  "user_id"
    t.integer  "place_id"
    t.string   "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "reviews", ["user_id"], :name => "index_reviews_on_user_id"

  create_table "selections", :force => true do |t|
    t.string   "picture"
    t.integer  "user_id"
    t.string   "kind"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "selections", ["user_id"], :name => "index_selections_on_user_id"

  create_table "static_page_translations", :force => true do |t|
    t.integer  "static_page_id"
    t.string   "locale"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "static_page_translations", ["locale"], :name => "index_static_page_translations_on_locale"
  add_index "static_page_translations", ["static_page_id"], :name => "index_static_page_translations_on_static_page_id"

  create_table "static_pages", :force => true do |t|
    t.integer  "structure_id",                   :null => false
    t.integer  "user_id"
    t.boolean  "is_visible",   :default => true, :null => false
    t.boolean  "delta",        :default => true, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "static_pages", ["structure_id"], :name => "fk_pages"
  add_index "static_pages", ["user_id"], :name => "index_static_pages_on_user_id"

  create_table "structure_translations", :force => true do |t|
    t.integer  "structure_id"
    t.string   "locale"
    t.string   "title"
    t.string   "redirect_url"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "structure_translations", ["locale"], :name => "index_structure_translations_on_locale"
  add_index "structure_translations", ["structure_id"], :name => "index_structure_translations_on_structure_id"

  create_table "structures", :force => true do |t|
    t.string   "slug",       :limit => 50,                   :null => false
    t.integer  "kind",       :limit => 1,  :default => 1
    t.integer  "position",   :limit => 2,  :default => 1
    t.integer  "user_id"
    t.boolean  "is_visible",               :default => true, :null => false
    t.boolean  "delta",                    :default => true, :null => false
    t.integer  "parent_id"
    t.integer  "lft",                      :default => 0
    t.integer  "rgt",                      :default => 0
    t.integer  "depth",                    :default => 0
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "structures", ["kind", "slug"], :name => "index_structures_on_kind_and_slug", :unique => true
  add_index "structures", ["lft", "rgt"], :name => "index_structures_on_lft_and_rgt"
  add_index "structures", ["parent_id"], :name => "index_structures_on_parent_id"
  add_index "structures", ["user_id"], :name => "index_structures_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "login",                  :limit => 20
    t.integer  "user_role_id",           :limit => 1,  :default => 1
    t.integer  "trust_state",            :limit => 1,  :default => 1
    t.string   "first_name"
    t.string   "last_name"
    t.string   "patronymic"
    t.string   "phone"
    t.string   "address"
    t.datetime "birthday"
    t.integer  "account_id"
    t.string   "email"
    t.string   "encrypted_password",                   :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "password_salt"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                      :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.string   "photo"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email", "account_id"], :name => "index_users_on_email_and_account_id"
  add_index "users", ["last_name", "first_name", "patronymic"], :name => "index_users_on_last_name_and_first_name_and_patronymic"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
