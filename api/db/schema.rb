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

ActiveRecord::Schema.define(:version => 20110514160650) do

  create_table "points", :force => true do |t|
    t.string "latitude",  :null => false
    t.string "longitude", :null => false
  end

  create_table "steps", :force => true do |t|
    t.integer  "trip_id",          :null => false
    t.string   "distance"
    t.string   "instructions"
    t.integer  "start_point_id",   :null => false
    t.integer  "end_point_id",     :null => false
    t.integer  "next_step_id"
    t.integer  "previous_step_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "steps", ["trip_id"], :name => "index_steps_on_trip_id"

  create_table "trips", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "origin",      :null => false
    t.string   "destination", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trips", ["name"], :name => "index_trips_on_name"

end
