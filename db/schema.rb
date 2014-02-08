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

ActiveRecord::Schema.define(version: 20130916213040) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "airports", force: true do |t|
    t.string  "name"
    t.string  "iata"
    t.float   "lat"
    t.float   "lng"
    t.integer "city_id"
  end

  create_table "cities", force: true do |t|
    t.string "name"
    t.string "country_iso"
    t.float  "lat"
    t.float  "lng"
    t.string "code"
  end

  add_index "cities", ["lat", "lng"], name: "index_cities_on_lat_and_lng", using: :btree

end
