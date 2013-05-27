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

ActiveRecord::Schema.define(:version => 20130527124750) do

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
    t.string   "city"
  end

  create_table "categories", :force => true do |t|
    t.string   "slug",                                  :null => false
    t.integer  "user_id"
    t.boolean  "is_visible",         :default => true,  :null => false
    t.integer  "parent_id"
    t.integer  "lft",                :default => 0
    t.integer  "rgt",                :default => 0
    t.integer  "depth",              :default => 0
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.boolean  "is_visible_on_main", :default => false
    t.integer  "position"
    t.string   "css_id"
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
    t.string   "plural_name"
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
    t.integer  "country_id"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "phone_code"
  end

  add_index "cities", ["country_id"], :name => "index_cities_on_country_id"
  add_index "cities", ["slug"], :name => "index_cities_on_slug", :unique => true

  create_table "city_translations", :force => true do |t|
    t.integer  "city_id"
    t.string   "locale"
    t.string   "name"
    t.text     "description"
    t.string   "plural_name"
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
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "cooperations", :force => true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "phone"
    t.string   "place_name"
    t.string   "city"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "countries", :force => true do |t|
    t.string   "slug"
    t.boolean  "is_visible", :default => true
    t.integer  "position",   :default => 0
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "countries", ["slug"], :name => "index_countries_on_slug", :unique => true

  create_table "country_translations", :force => true do |t|
    t.integer  "country_id"
    t.string   "locale"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "country_translations", ["country_id"], :name => "index_country_translations_on_country_id"
  add_index "country_translations", ["locale"], :name => "index_country_translations_on_locale"

  create_table "day_discount_translations", :force => true do |t|
    t.integer  "day_discount_id"
    t.string   "locale"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "day_discount_translations", ["day_discount_id"], :name => "index_1ef7a097c4517b0a80521b1368f9f8b91af33d0d"
  add_index "day_discount_translations", ["locale"], :name => "index_day_discount_translations_on_locale"

  create_table "day_discounts", :force => true do |t|
    t.integer  "week_day_id"
    t.decimal  "from_time",   :precision => 4, :scale => 2
    t.decimal  "to_time",     :precision => 4, :scale => 2
    t.float    "discount"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "is_discount"
  end

  add_index "day_discounts", ["week_day_id"], :name => "index_day_discounts_on_week_day_id"

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

  create_table "group_roles", :force => true do |t|
    t.integer  "group_id"
    t.integer  "role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "group_roles", ["group_id"], :name => "index_group_roles_on_group_id"
  add_index "group_roles", ["role_id"], :name => "index_group_roles_on_role_id"

  create_table "group_users", :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.boolean  "is_chief",   :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "group_users", ["group_id"], :name => "index_group_users_on_group_id"
  add_index "group_users", ["user_id"], :name => "index_group_users_on_user_id"

  create_table "groups", :force => true do |t|
    t.integer  "group_type_id", :limit => 2, :default => 1
    t.integer  "user_id"
    t.boolean  "is_visible",                 :default => true, :null => false
    t.boolean  "delta",                      :default => true, :null => false
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  add_index "groups", ["user_id"], :name => "index_groups_on_user_id"

  create_table "header_translations", :force => true do |t|
    t.integer  "header_id"
    t.string   "locale"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "header_translations", ["header_id"], :name => "index_header_translations_on_header_id"
  add_index "header_translations", ["locale"], :name => "index_header_translations_on_locale"

  create_table "headers", :force => true do |t|
    t.string   "headerable_type", :limit => 30, :null => false
    t.integer  "headerable_id",                 :null => false
    t.integer  "tag_type_id",                   :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "headers", ["headerable_type", "headerable_id"], :name => "index_headers_on_headerable_type_and_headerable_id"
  add_index "headers", ["tag_type_id"], :name => "index_headers_on_tag_type_id"

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

  create_table "letter_translations", :force => true do |t|
    t.integer  "letter_id"
    t.string   "locale"
    t.string   "topic"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "letter_translations", ["letter_id"], :name => "index_letter_translations_on_letter_id"
  add_index "letter_translations", ["locale"], :name => "index_letter_translations_on_locale"

  create_table "letters", :force => true do |t|
    t.integer  "kind",                         :null => false
    t.boolean  "is_visible", :default => true
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

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
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.boolean  "included_in_overall", :default => true
    t.boolean  "is_noise",            :default => false
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

  create_table "og_tag_translations", :force => true do |t|
    t.integer  "og_tag_id"
    t.string   "locale"
    t.string   "title"
    t.text     "description"
    t.string   "url"
    t.string   "image"
    t.string   "site_name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "og_tag_translations", ["locale"], :name => "index_og_tag_translations_on_locale"
  add_index "og_tag_translations", ["og_tag_id"], :name => "index_og_tag_translations_on_og_tag_id"

  create_table "og_tags", :force => true do |t|
    t.string   "og_type"
    t.integer  "header_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "og_tags", ["header_id"], :name => "index_og_tags_on_header_id"

  create_table "permissions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "actions_mask"
    t.integer  "context",       :limit => 1, :default => 1
    t.integer  "subject",       :limit => 2, :default => 1
    t.integer  "subject_id"
    t.string   "assoc"
    t.string   "assoc_ids"
    t.boolean  "is_visibility",              :default => false
    t.boolean  "is_own",                     :default => false
    t.boolean  "is_work",                    :default => false
    t.integer  "role_id"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  add_index "permissions", ["subject", "subject_id"], :name => "index_permissions_on_subject_and_subject_id"
  add_index "permissions", ["user_id"], :name => "index_permissions_on_user_id"

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

  create_table "place_menu_item_translations", :force => true do |t|
    t.integer  "place_menu_item_id"
    t.string   "locale"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "place_menu_item_translations", ["locale"], :name => "index_place_menu_item_translations_on_locale"
  add_index "place_menu_item_translations", ["place_menu_item_id"], :name => "index_2c48ed73e5a0ec59a6a95609f60003d4f831b8d7"

  create_table "place_menu_items", :force => true do |t|
    t.float    "price",         :default => 0.0
    t.integer  "place_menu_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "place_menu_items", ["place_menu_id"], :name => "index_place_menu_items_on_place_menu_id"

  create_table "place_menu_translations", :force => true do |t|
    t.integer  "place_menu_id"
    t.string   "locale"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "place_menu_translations", ["locale"], :name => "index_place_menu_translations_on_locale"
  add_index "place_menu_translations", ["place_menu_id"], :name => "index_place_menu_translations_on_place_menu_id"

  create_table "place_menus", :force => true do |t|
    t.integer  "place_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "place_menus", ["place_id"], :name => "index_place_menus_on_place_id"

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
    t.integer  "city_id"
  end

  add_index "places", ["slug"], :name => "index_places_on_slug", :unique => true
  add_index "places", ["user_id"], :name => "index_places_on_user_id"

  create_table "places_selections", :id => false, :force => true do |t|
    t.integer "place_id"
    t.integer "selection_id"
  end

  create_table "reservations", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "email"
    t.text     "special_notes"
    t.datetime "time"
    t.integer  "user_id"
    t.integer  "place_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "persons"
    t.boolean  "is_sms_send",   :default => false
    t.integer  "phone_code_id"
  end

  add_index "reservations", ["place_id"], :name => "index_reservations_on_place_id"
  add_index "reservations", ["user_id"], :name => "index_reservations_on_user_id"

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

  create_table "role_translations", :force => true do |t|
    t.integer  "role_id"
    t.string   "locale"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "role_translations", ["locale"], :name => "index_role_translations_on_locale"
  add_index "role_translations", ["role_id"], :name => "index_role_translations_on_role_id"

  create_table "roles", :force => true do |t|
    t.integer  "role_type_id", :limit => 2, :default => 1
    t.integer  "user_id"
    t.boolean  "is_visible",                :default => true, :null => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  add_index "roles", ["user_id"], :name => "index_roles_on_user_id"

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
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "static_pages", ["structure_id"], :name => "fk_pages"
  add_index "static_pages", ["user_id"], :name => "index_static_pages_on_user_id"

  create_table "structure_translations", :force => true do |t|
    t.integer  "structure_id"
    t.string   "locale"
    t.string   "title"
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

  create_table "u_user_notifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "user_notification_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "u_user_notifications", ["user_notification_id", "user_id"], :name => "index_u_user_notifications_on_user_notification_id_and_user_id"

  create_table "user_favorite_places", :force => true do |t|
    t.integer  "user_id"
    t.integer  "place_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_favorite_places", ["place_id"], :name => "index_user_favorite_places_on_place_id"
  add_index "user_favorite_places", ["user_id"], :name => "index_user_favorite_places_on_user_id"

  create_table "user_notification_translations", :force => true do |t|
    t.integer  "user_notification_id"
    t.string   "locale"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "user_notification_translations", ["locale"], :name => "index_user_notification_translations_on_locale"
  add_index "user_notification_translations", ["user_notification_id"], :name => "index_fab75e15c90f53eedb098629cadbb951fec50d69"

  create_table "user_notifications", :force => true do |t|
    t.integer  "position",   :default => 0
    t.boolean  "is_visible", :default => true
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

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
    t.string   "encrypted_password",                   :default => "",  :null => false
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
    t.integer  "city_id"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.float    "points",                               :default => 0.0
  end

  add_index "users", ["city_id"], :name => "index_users_on_city_id"
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email", "account_id"], :name => "index_users_on_email_and_account_id"
  add_index "users", ["last_name", "first_name", "patronymic"], :name => "index_users_on_last_name_and_first_name_and_patronymic"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "vote_type_translations", :force => true do |t|
    t.integer  "vote_type_id"
    t.string   "locale"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "vote_type_translations", ["locale"], :name => "index_vote_type_translations_on_locale"
  add_index "vote_type_translations", ["vote_type_id"], :name => "index_vote_type_translations_on_vote_type_id"

  create_table "vote_types", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "review_id"
    t.integer  "vote_type_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "votes", ["review_id"], :name => "index_votes_on_review_id"
  add_index "votes", ["user_id"], :name => "index_votes_on_user_id"
  add_index "votes", ["vote_type_id"], :name => "index_votes_on_vote_type_id"

  create_table "week_days", :force => true do |t|
    t.decimal  "start_at",    :precision => 4, :scale => 2
    t.decimal  "end_at",      :precision => 4, :scale => 2
    t.integer  "day_type_id",                                                  :null => false
    t.boolean  "is_working",                                :default => false
    t.integer  "place_id"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
  end

  add_index "week_days", ["day_type_id"], :name => "index_week_days_on_day_type_id"
  add_index "week_days", ["place_id"], :name => "index_week_days_on_place_id"

end
