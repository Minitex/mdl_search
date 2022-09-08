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

ActiveRecord::Schema.define(version: 2022_07_14_163566) do

  create_table "bookmarks", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "user_type"
    t.string "document_id"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "document_type"
    t.index ["document_type", "document_id"], name: "index_bookmarks_on_document_type_and_document_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "friendly_id_slugs", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, length: { slug: 70, scope: 70 }
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", length: { slug: 140 }
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "indexing_runs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jobs", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "indexing_run_id"
    t.string "job_id", null: false
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["completed_at"], name: "index_jobs_on_completed_at"
    t.index ["indexing_run_id"], name: "index_jobs_on_indexing_run_id"
    t.index ["job_id"], name: "index_jobs_on_job_id"
  end

  create_table "searches", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "query_params", size: :medium
    t.integer "user_id"
    t.string "user_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_searches_on_user_id"
  end

  create_table "spotlight_attachments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.string "file"
    t.string "uid"
    t.integer "exhibit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spotlight_blacklight_configurations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "exhibit_id"
    t.text "facet_fields"
    t.text "index_fields"
    t.text "search_fields"
    t.text "sort_fields"
    t.text "default_solr_params"
    t.text "show"
    t.text "index"
    t.integer "default_per_page"
    t.text "per_page"
    t.text "document_index_view_types"
    t.string "thumbnail_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spotlight_bulk_updates", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "file", null: false
    t.bigint "exhibit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exhibit_id"], name: "index_spotlight_bulk_updates_on_exhibit_id"
  end

  create_table "spotlight_contact_emails", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "exhibit_id"
    t.string "email", default: "", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["confirmation_token"], name: "index_spotlight_contact_emails_on_confirmation_token", unique: true
    t.index ["email", "exhibit_id"], name: "index_spotlight_contact_emails_on_email_and_exhibit_id", unique: true
  end

  create_table "spotlight_contacts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "slug"
    t.string "name"
    t.string "email"
    t.string "title"
    t.string "location"
    t.string "telephone"
    t.boolean "show_in_sidebar"
    t.integer "weight", default: 50
    t.integer "exhibit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "contact_info"
    t.string "avatar"
    t.integer "avatar_crop_x"
    t.integer "avatar_crop_y"
    t.integer "avatar_crop_w"
    t.integer "avatar_crop_h"
    t.integer "avatar_id"
    t.index ["avatar_id"], name: "index_spotlight_contacts_on_avatar_id"
    t.index ["exhibit_id"], name: "index_spotlight_contacts_on_exhibit_id"
  end

  create_table "spotlight_custom_fields", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "exhibit_id"
    t.string "slug"
    t.string "field"
    t.text "configuration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "field_type"
    t.boolean "readonly_field", default: false
    t.boolean "is_multiple", default: false
  end

  create_table "spotlight_custom_search_fields", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "slug"
    t.string "field"
    t.text "configuration"
    t.bigint "exhibit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exhibit_id"], name: "index_spotlight_custom_search_fields_on_exhibit_id"
  end

  create_table "spotlight_events", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "exhibit_id"
    t.string "resource_type", null: false
    t.bigint "resource_id", null: false
    t.string "type"
    t.string "collation_key"
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exhibit_id"], name: "index_spotlight_events_on_exhibit_id"
    t.index ["resource_type", "resource_id"], name: "index_spotlight_events_on_resource_type_and_resource_id"
  end

  create_table "spotlight_exhibits", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "title", null: false
    t.string "subtitle"
    t.string "slug"
    t.text "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "layout"
    t.boolean "published", default: false
    t.datetime "published_at"
    t.string "featured_image"
    t.integer "masthead_id"
    t.integer "thumbnail_id"
    t.integer "weight", default: 50
    t.integer "site_id"
    t.string "theme"
    t.index ["masthead_id"], name: "index_spotlight_exhibits_on_masthead_id"
    t.index ["site_id"], name: "index_spotlight_exhibits_on_site_id"
    t.index ["slug"], name: "index_spotlight_exhibits_on_slug", unique: true
    t.index ["thumbnail_id"], name: "index_spotlight_exhibits_on_thumbnail_id"
  end

  create_table "spotlight_featured_images", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "type"
    t.boolean "display"
    t.string "image"
    t.string "source"
    t.string "document_global_id"
    t.integer "image_crop_x"
    t.integer "image_crop_y"
    t.integer "image_crop_w"
    t.integer "image_crop_h"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "iiif_region"
    t.string "iiif_manifest_url"
    t.string "iiif_canvas_id"
    t.string "iiif_image_id"
    t.string "iiif_tilesource"
  end

  create_table "spotlight_filters", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "field"
    t.string "value"
    t.integer "exhibit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exhibit_id"], name: "index_spotlight_filters_on_exhibit_id"
  end

  create_table "spotlight_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "slug"
    t.text "title"
    t.bigint "exhibit_id"
    t.integer "weight", default: 50
    t.boolean "published"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exhibit_id"], name: "index_spotlight_groups_on_exhibit_id"
  end

  create_table "spotlight_groups_members", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "group_id"
    t.string "member_type"
    t.bigint "member_id"
    t.index ["group_id"], name: "index_spotlight_groups_members_on_group_id"
    t.index ["member_type", "member_id"], name: "index_spotlight_groups_members_on_member_type_and_member_id"
  end

  create_table "spotlight_job_trackers", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "on_type", null: false
    t.bigint "on_id", null: false
    t.string "resource_type", null: false
    t.bigint "resource_id", null: false
    t.string "job_id"
    t.string "job_class"
    t.string "parent_job_id"
    t.string "parent_job_class"
    t.string "status"
    t.bigint "user_id"
    t.text "log"
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_spotlight_job_trackers_on_job_id"
    t.index ["on_type", "on_id"], name: "index_spotlight_job_trackers_on_on_type_and_on_id"
    t.index ["resource_type", "resource_id"], name: "index_spotlight_job_trackers_on_resource_type_and_resource_id"
    t.index ["user_id"], name: "index_spotlight_job_trackers_on_user_id"
  end

  create_table "spotlight_languages", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "locale", null: false
    t.boolean "public"
    t.string "text"
    t.integer "exhibit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exhibit_id"], name: "index_spotlight_languages_on_exhibit_id"
  end

  create_table "spotlight_locks", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "on_type"
    t.integer "on_id"
    t.string "by_type"
    t.integer "by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["on_id", "on_type"], name: "index_spotlight_locks_on_on_id_and_on_type", unique: true
  end

  create_table "spotlight_main_navigations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "label"
    t.integer "weight", default: 20
    t.string "nav_type"
    t.integer "exhibit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "display", default: true
    t.index ["exhibit_id"], name: "index_spotlight_main_navigations_on_exhibit_id"
  end

  create_table "spotlight_pages", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "title"
    t.string "type"
    t.string "slug"
    t.string "scope"
    t.text "content", size: :medium
    t.integer "weight", default: 1000
    t.boolean "published"
    t.integer "exhibit_id"
    t.integer "created_by_id"
    t.integer "last_edited_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "parent_page_id"
    t.boolean "display_sidebar"
    t.boolean "display_title"
    t.integer "thumbnail_id"
    t.string "locale", default: "en"
    t.integer "default_locale_page_id"
    t.string "content_type"
    t.index ["default_locale_page_id"], name: "index_spotlight_pages_on_default_locale_page_id"
    t.index ["exhibit_id"], name: "index_spotlight_pages_on_exhibit_id"
    t.index ["locale"], name: "index_spotlight_pages_on_locale"
    t.index ["parent_page_id"], name: "index_spotlight_pages_on_parent_page_id"
    t.index ["slug", "scope"], name: "index_spotlight_pages_on_slug_and_scope", unique: true
    t.index ["thumbnail_id"], name: "index_spotlight_pages_on_thumbnail_id"
  end

  create_table "spotlight_reindexing_log_entries", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "items_reindexed_count"
    t.integer "items_reindexed_estimate"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "job_status"
    t.integer "exhibit_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spotlight_resources", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "exhibit_id"
    t.string "type"
    t.string "url"
    t.text "data"
    t.datetime "indexed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.binary "metadata"
    t.integer "index_status"
    t.integer "upload_id"
    t.index ["index_status"], name: "index_spotlight_resources_on_index_status"
    t.index ["upload_id"], name: "index_spotlight_resources_on_upload_id"
  end

  create_table "spotlight_roles", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "user_id"
    t.string "role"
    t.integer "resource_id"
    t.string "resource_type"
    t.index ["resource_type", "resource_id", "user_id"], name: "index_spotlight_roles_on_resource_and_user_id", unique: true
  end

  create_table "spotlight_searches", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.string "scope"
    t.text "short_description"
    t.text "long_description"
    t.text "query_params"
    t.integer "weight"
    t.boolean "published"
    t.integer "exhibit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "featured_item_id"
    t.integer "masthead_id"
    t.integer "thumbnail_id"
    t.string "default_index_view_type"
    t.boolean "search_box", default: false
    t.string "subtitle"
    t.index ["exhibit_id"], name: "index_spotlight_searches_on_exhibit_id"
    t.index ["masthead_id"], name: "index_spotlight_searches_on_masthead_id"
    t.index ["slug", "scope"], name: "index_spotlight_searches_on_slug_and_scope", unique: true
    t.index ["thumbnail_id"], name: "index_spotlight_searches_on_thumbnail_id"
  end

  create_table "spotlight_sites", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "title"
    t.string "subtitle"
    t.integer "masthead_id"
  end

  create_table "spotlight_solr_document_sidecars", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "exhibit_id"
    t.boolean "public", default: true
    t.text "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "document_id"
    t.string "document_type"
    t.integer "resource_id"
    t.string "resource_type"
    t.binary "index_status", size: :medium
    t.index ["document_type", "document_id"], name: "spotlight_solr_document_sidecars_solr_document"
    t.index ["exhibit_id", "document_type", "document_id"], name: "by_exhibit_and_doc", unique: true
    t.index ["exhibit_id", "document_type", "document_id"], name: "spotlight_solr_document_sidecars_exhibit_document"
    t.index ["exhibit_id"], name: "index_spotlight_solr_document_sidecars_on_exhibit_id"
    t.index ["resource_type", "resource_id"], name: "spotlight_solr_document_sidecars_resource"
  end

  create_table "taggings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string "taggable_type"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name", collation: "utf8_bin"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "translations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "locale"
    t.string "key"
    t.text "value"
    t.text "interpolations"
    t.boolean "is_proc", default: false
    t.integer "exhibit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exhibit_id", "key", "locale"], name: "index_translations_on_exhibit_id_and_key_and_locale", unique: true
    t.index ["exhibit_id"], name: "index_translations_on_exhibit_id"
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "roles_mask"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "item_type", limit: 191, null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", size: :long
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end
