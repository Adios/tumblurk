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

ActiveRecord::Schema.define(:version => 6) do

  create_table "blogs", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.string   "description"
    t.boolean  "private"
    t.boolean  "default_blog"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blogs_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "blog_id"
  end

  create_table "posts", :force => true do |t|
    t.string   "kind"
    t.text     "head"
    t.text     "body"
    t.boolean  "visible",    :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "publish_at"
    t.integer  "user_id"
    t.string   "session"
    t.integer  "origin_id"
    t.integer  "blog_id"
  end

  create_table "posts_tags", :id => false, :force => true do |t|
    t.integer "post_id"
    t.integer "tag_id"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "email"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
