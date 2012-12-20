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

ActiveRecord::Schema.define(:version => 20121220151632) do

  create_table "account_email_confirmations", :force => true do |t|
    t.string   "confirmation_token"
    t.string   "unconfirmed_email"
    t.datetime "confirmed_sent_at"
    t.datetime "confirmed_at"
    t.integer  "account_id"
    t.integer  "failed_attempts",    :default => 0
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "account_email_confirmations", ["account_id"], :name => "index_account_email_confirmations_on_account_id"
  add_index "account_email_confirmations", ["confirmation_token"], :name => "index_account_email_confirmations_on_confirmation_token"

  create_table "accounts", :force => true do |t|
    t.string   "provider",      :limit => 100,                :null => false
    t.string   "name"
    t.string   "nickname"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.string   "photo"
    t.string   "url"
    t.string   "address"
    t.string   "language"
    t.string   "birthday"
    t.string   "token"
    t.string   "refresh_token"
    t.string   "secret"
    t.integer  "gender",        :limit => 1,   :default => 2
    t.string   "uid",                                         :null => false
    t.integer  "user_id"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  add_index "accounts", ["email"], :name => "index_accounts_on_email"
  add_index "accounts", ["provider", "uid"], :name => "idx_accounts_provider_uid"
  add_index "accounts", ["user_id"], :name => "index_accounts_on_user_id"

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

  create_table "autocompletes", :force => true do |t|
    t.string   "term"
    t.integer  "freq"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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

  create_table "cities", :force => true do |t|
    t.string   "slug",                         :null => false
    t.boolean  "is_visible", :default => true
    t.integer  "position"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "cities", ["slug"], :name => "index_cities_on_slug", :unique => true

  create_table "city_translations", :force => true do |t|
    t.integer  "city_id"
    t.string   "locale"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "city_translations", ["city_id"], :name => "index_city_translations_on_city_id"
  add_index "city_translations", ["locale"], :name => "index_city_translations_on_locale"

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

  create_table "day_discount_schedules", :force => true do |t|
    t.integer  "place_id"
    t.integer  "day_type_id"
    t.boolean  "is_running",  :default => true
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "day_discount_schedules", ["day_type_id"], :name => "index_day_discount_schedules_on_day_type_id"
  add_index "day_discount_schedules", ["place_id"], :name => "index_day_discount_schedules_on_place_id"

  create_table "day_discounts", :force => true do |t|
    t.integer  "day_discount_schedule_id"
    t.time     "from_time"
    t.time     "to_time"
    t.float    "discount"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

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

  create_table "feature_item_translations", :force => true do |t|
    t.integer  "feature_item_id"
    t.string   "locale"
    t.string   "name"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "feature_item_translations", ["feature_item_id"], :name => "index_3de1035375aafd880dbde54fdecda400f771e7e7"
  add_index "feature_item_translations", ["locale"], :name => "index_feature_item_translations_on_locale"

  create_table "feature_items", :force => true do |t|
    t.boolean  "is_visible",       :default => true
    t.integer  "group_feature_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "feature_items", ["group_feature_id"], :name => "index_feature_items_on_group_feature_id"

  create_table "friends", :force => true do |t|
    t.string   "social_id",  :null => false
    t.string   "name"
    t.string   "type"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "friends", ["social_id"], :name => "index_friends_on_social_id"
  add_index "friends", ["user_id"], :name => "index_friends_on_user_id"

  create_table "group_feature_categories", :force => true do |t|
    t.integer  "group_feature_id"
    t.integer  "category_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "group_feature_categories", ["category_id"], :name => "index_group_feature_categories_on_category_id"
  add_index "group_feature_categories", ["group_feature_id"], :name => "index_group_feature_categories_on_group_feature_id"

  create_table "group_feature_translations", :force => true do |t|
    t.integer  "group_feature_id"
    t.string   "locale"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "group_feature_translations", ["group_feature_id"], :name => "index_e9eef5999879b3140148a9dd0a0303483b07b08e"
  add_index "group_feature_translations", ["locale"], :name => "index_group_feature_translations_on_locale"

  create_table "group_features", :force => true do |t|
    t.boolean  "is_visible", :default => true
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

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

  create_table "location_translations", :force => true do |t|
    t.integer  "location_id"
    t.string   "locale"
    t.string   "street"
    t.string   "city"
    t.string   "country"
    t.string   "county"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "location_translations", ["locale"], :name => "index_location_translations_on_locale"
  add_index "location_translations", ["location_id"], :name => "index_location_translations_on_location_id"

  create_table "locations", :force => true do |t|
    t.integer  "locationable_id",                 :null => false
    t.string   "locationable_type", :limit => 50, :null => false
    t.string   "zip"
    t.float    "latitude"
    t.float    "longitude"
    t.float    "distance"
    t.string   "house_number"
    t.string   "country_code"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "locations", ["locationable_id", "locationable_type"], :name => "index_locations_on_locationable_id_and_locationable_type"

  create_table "mark_type_translations", :force => true do |t|
    t.integer  "mark_type_id"
    t.string   "locale"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "mark_type_translations", ["locale"], :name => "index_mark_type_translations_on_locale"
  add_index "mark_type_translations", ["mark_type_id"], :name => "index_mark_type_translations_on_mark_type_id"

  create_table "mark_types", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "marks", :force => true do |t|
    t.integer  "value"
    t.integer  "mark_type_id"
    t.integer  "review_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "marks", ["mark_type_id"], :name => "index_marks_on_mark_type_id"
  add_index "marks", ["review_id"], :name => "index_marks_on_review_id"

  create_table "notes", :force => true do |t|
    t.integer  "place_id"
    t.string   "picture"
    t.string   "title"
    t.string   "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "place_administrators", :force => true do |t|
    t.integer  "place_id"
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "place_administrators", ["place_id"], :name => "index_place_administrators_on_place_id"

  create_table "place_categories", :force => true do |t|
    t.integer  "category_id"
    t.integer  "place_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "place_categories", ["category_id"], :name => "index_place_categories_on_category_id"
  add_index "place_categories", ["place_id"], :name => "index_place_categories_on_place_id"

  create_table "place_feature_items", :force => true do |t|
    t.integer  "place_id"
    t.integer  "feature_item_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "place_feature_items", ["feature_item_id"], :name => "index_place_feature_items_on_feature_item_id"
  add_index "place_feature_items", ["place_id"], :name => "index_place_feature_items_on_place_id"

  create_table "place_kitchens", :force => true do |t|
    t.integer  "place_id"
    t.integer  "kitchen_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "place_kitchens", ["kitchen_id"], :name => "index_place_kitchens_on_kitchen_id"
  add_index "place_kitchens", ["place_id"], :name => "index_place_kitchens_on_place_id"

  create_table "place_translations", :force => true do |t|
    t.integer  "place_id"
    t.string   "locale"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "place_translations", ["locale"], :name => "index_place_translations_on_locale"
  add_index "place_translations", ["place_id"], :name => "index_place_translations_on_place_id"

  create_table "places", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "user_id"
    t.boolean  "is_visible", :default => true, :null => false
    t.string   "phone"
    t.string   "url"
    t.integer  "avg_bill"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "places", ["slug"], :name => "index_places_on_slug", :unique => true
  add_index "places", ["user_id"], :name => "index_places_on_user_id"

  create_table "places_selections", :id => false, :force => true do |t|
    t.integer "place_id"
    t.integer "selection_id"
  end

  create_table "reviews", :force => true do |t|
    t.integer  "reviewable_id"
    t.string   "reviewable_type"
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "reviews", ["reviewable_id", "reviewable_type"], :name => "index_reviews_on_reviewable_id_and_reviewable_type"
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

  create_table "user_roles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_roles", ["role_id"], :name => "index_user_roles_on_role_id"
  add_index "user_roles", ["user_id"], :name => "index_user_roles_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "login",                  :limit => 20
    t.integer  "user_role_id",           :limit => 1,  :default => 1
    t.integer  "trust_state",            :limit => 1,  :default => 1
    t.string   "first_name"
    t.string   "last_name"
    t.string   "patronymic"
    t.string   "phone"
    t.string   "address"
    t.integer  "gender",                 :limit => 1,  :default => 2
    t.date     "birthday"
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
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email", "account_id"], :name => "index_users_on_email_and_account_id"
  add_index "users", ["last_name", "first_name", "patronymic"], :name => "index_users_on_last_name_and_first_name_and_patronymic"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "week_day_translations", :force => true do |t|
    t.integer  "week_day_id"
    t.string   "locale"
    t.string   "title"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "week_day_translations", ["locale"], :name => "index_week_day_translations_on_locale"
  add_index "week_day_translations", ["week_day_id"], :name => "index_week_day_translations_on_week_day_id"

  create_table "week_days", :force => true do |t|
    t.float    "start_at"
    t.float    "end_at"
    t.float    "start_break_at"
    t.float    "end_break_at"
    t.integer  "place_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "week_days", ["place_id"], :name => "index_week_days_on_place_id"

end
