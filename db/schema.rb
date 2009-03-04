# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090303154248) do

  create_table "article_versions", :force => true do |t|
    t.integer  "article_id"
    t.integer  "version"
    t.text     "title"
    t.text     "description"
    t.datetime "created_at"
    t.integer  "parent_id"
    t.text     "body"
    t.integer  "owner_id"
    t.string   "content_type", :default => "application/xhtml+xml"
    t.datetime "updated_at"
    t.string   "owner_type"
    t.integer  "author_id"
    t.boolean  "public_read"
    t.string   "author_type"
  end

  create_table "articles", :force => true do |t|
    t.text     "title"
    t.text     "description"
    t.datetime "created_at"
    t.integer  "parent_id"
    t.text     "body"
    t.integer  "owner_id"
    t.string   "content_type", :default => "application/xhtml+xml"
    t.integer  "version"
    t.string   "owner_type"
    t.datetime "updated_at"
    t.integer  "author_id"
    t.boolean  "public_read"
    t.string   "author_type"
  end

  create_table "audios", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "content_type"
    t.integer  "size"
    t.integer  "db_file_id"
    t.string   "filename"
    t.integer  "author_id"
    t.boolean  "public_read"
    t.string   "author_type"
  end

  create_table "bookmarks", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "author_id"
    t.boolean  "public_read"
    t.string   "author_type"
    t.integer  "uri_id"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "domain_id"
    t.string   "domain_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.text     "description"
    t.boolean  "public_read"
  end

  create_table "categories_profiles", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "profile_id"
  end

  create_table "categorizations", :force => true do |t|
    t.integer "categorizable_id"
    t.string  "categorizable_type"
    t.integer "category_id"
  end

  create_table "contacts", :force => true do |t|
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "destination_id"
    t.string   "destination_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "db_files", :force => true do |t|
    t.binary "data"
  end

  create_table "document_versions", :force => true do |t|
    t.integer  "document_id"
    t.integer  "version"
    t.string   "title"
    t.text     "description"
    t.integer  "author_id"
    t.string   "author_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "content_type"
    t.integer  "size"
    t.integer  "db_file_id"
    t.string   "filename"
    t.string   "public_read"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "author_id"
    t.string   "author_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "content_type"
    t.integer  "size"
    t.integer  "db_file_id"
    t.string   "filename"
    t.string   "public_read"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version"
  end

  create_table "globalize_countries", :force => true do |t|
    t.string "code",                   :limit => 2
    t.string "english_name"
    t.string "date_format"
    t.string "currency_format"
    t.string "currency_code",          :limit => 3
    t.string "thousands_sep",          :limit => 2
    t.string "decimal_sep",            :limit => 2
    t.string "currency_decimal_sep",   :limit => 2
    t.string "number_grouping_scheme"
  end

  add_index "globalize_countries", ["code"], :name => "index_globalize_countries_on_code"

  create_table "globalize_languages", :force => true do |t|
    t.string  "iso_639_1",             :limit => 2
    t.string  "iso_639_2",             :limit => 3
    t.string  "iso_639_3",             :limit => 3
    t.string  "rfc_3066"
    t.string  "english_name"
    t.string  "english_name_locale"
    t.string  "english_name_modifier"
    t.string  "native_name"
    t.string  "native_name_locale"
    t.string  "native_name_modifier"
    t.boolean "macro_language"
    t.string  "direction"
    t.string  "pluralization"
    t.string  "scope",                 :limit => 1
  end

  add_index "globalize_languages", ["iso_639_1"], :name => "index_globalize_languages_on_iso_639_1"
  add_index "globalize_languages", ["iso_639_2"], :name => "index_globalize_languages_on_iso_639_2"
  add_index "globalize_languages", ["iso_639_3"], :name => "index_globalize_languages_on_iso_639_3"
  add_index "globalize_languages", ["rfc_3066"], :name => "index_globalize_languages_on_rfc_3066"

  create_table "globalize_translations", :force => true do |t|
    t.string  "type"
    t.string  "tr_key"
    t.string  "table_name"
    t.integer "item_id"
    t.string  "facet"
    t.boolean "built_in",            :default => true
    t.integer "language_id"
    t.integer "pluralization_index"
    t.text    "text"
    t.string  "namespace"
  end

  add_index "globalize_translations", ["table_name", "item_id", "language_id"], :name => "globalize_translations_table_name_and_item_and_language"
  add_index "globalize_translations", ["tr_key", "language_id"], :name => "index_globalize_translations_on_tr_key_and_language_id"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "others_write_members"
    t.boolean  "others_read_content"
    t.boolean  "others_read_members"
    t.boolean  "members_read_members"
    t.boolean  "members_write_members"
    t.boolean  "members_read_content"
    t.boolean  "members_write_content"
    t.boolean  "others_write_content"
    t.integer  "user_id"
  end

  create_table "identity_ownings", :force => true do |t|
    t.integer  "owning_agent_id"
    t.integer  "ar_uri_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "owning_agent_type"
  end

  create_table "identity_trusts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "ar_uri_id"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", :force => true do |t|
    t.string   "code"
    t.string   "email"
    t.integer  "agent_id"
    t.string   "agent_type"
    t.integer  "stage_id"
    t.string   "stage_type"
    t.integer  "role_id"
    t.string   "acceptation_code"
    t.datetime "accepted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logos", :force => true do |t|
    t.integer  "agent_id"
    t.datetime "created_at"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "size"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.integer  "width"
    t.integer  "height"
    t.string   "agent_type"
    t.datetime "updated_at"
  end

  create_table "logotypes", :force => true do |t|
    t.integer  "logotypable_id"
    t.string   "logotypable_type"
    t.integer  "size"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "height"
    t.integer  "width"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.integer  "db_file_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "member_id"
    t.integer  "set_id"
    t.datetime "created_at"
    t.boolean  "deleted",     :default => false
    t.datetime "updated_at"
    t.integer  "profile_id"
    t.string   "member_type"
    t.string   "set_type"
  end

  create_table "open_id_associations", :force => true do |t|
    t.binary  "server_url"
    t.string  "handle"
    t.binary  "secret"
    t.integer "issued"
    t.integer "lifetime"
    t.string  "assoc_type"
  end

  create_table "open_id_nonces", :force => true do |t|
    t.string  "server_url", :default => "", :null => false
    t.integer "timestamp",                  :null => false
    t.string  "salt",       :default => "", :null => false
  end

  create_table "openid_users", :force => true do |t|
    t.integer  "identity_uri_id"
    t.string   "nickname"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "performances", :force => true do |t|
    t.integer "agent_id"
    t.string  "agent_type"
    t.integer "role_id"
    t.integer "stage_id"
    t.string  "stage_type"
  end

  create_table "permissions", :force => true do |t|
    t.string "action"
    t.string "objective"
  end

  create_table "permissions_roles", :id => false, :force => true do |t|
    t.integer "permission_id"
    t.integer "role_id"
  end

  create_table "photos", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.integer  "owner_id"
    t.string   "content_type"
    t.integer  "size"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.integer  "width"
    t.integer  "height"
    t.string   "owner_type"
    t.datetime "updated_at"
    t.integer  "db_file_id"
    t.string   "filename"
    t.integer  "author_id"
    t.boolean  "public_read"
    t.string   "author_type"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "last_online"
    t.string   "nickname"
    t.string   "email"
    t.string   "fullname"
    t.date     "dob"
    t.string   "gender"
    t.string   "postcode"
    t.string   "country"
    t.string   "language"
    t.string   "timezone"
    t.string   "type"
  end

  create_table "read_accesses", :force => true do |t|
    t.integer "read_content_id"
    t.string  "read_content_type"
    t.integer "read_agent_id"
    t.string  "read_agent_type"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
    t.string "stage_type"
  end

  create_table "singular_agents", :force => true do |t|
    t.string "type"
  end

  create_table "sites", :force => true do |t|
    t.string   "name",        :default => "CMSplugin powered Rails site"
    t.text     "description"
    t.string   "domain",      :default => "cms.example.org"
    t.string   "email",       :default => "admin@example.org"
    t.string   "locale"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "ssl",         :default => false
  end

  create_table "taggings", :force => true do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string  "taggable_type"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type"], :name => "index_taggings_on_tag_id_and_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "uris", :force => true do |t|
    t.string "uri"
  end

  add_index "uris", ["uri"], :name => "index_uris_on_uri"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.datetime "last_online"
    t.integer  "activation_count",                        :default => 0
    t.text     "description"
  end

  create_table "write_accesses", :force => true do |t|
    t.integer "write_content_id"
    t.string  "write_content_type"
    t.integer "write_agent_id"
    t.string  "write_agent_type"
  end

end
