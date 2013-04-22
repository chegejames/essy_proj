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

ActiveRecord::Schema.define(:version => 20130422030157) do

  create_table "members", :force => true do |t|
    t.string   "First_Name"
    t.string   "Last_Name"
    t.string   "Designation"
    t.string   "Email_Address"
    t.string   "Cell_Number"
    t.string   "Region"
    t.boolean  "active"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "payment_plans", :force => true do |t|
    t.integer  "Judge"
    t.integer  "Magistrate"
    t.integer  "Kadhi"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "payments", :force => true do |t|
    t.integer  "member_id"
    t.integer  "invoice"
    t.string   "mode_of_payment"
    t.string   "cheque_no"
    t.string   "bank_name"
    t.integer  "amount"
    t.integer  "total_amount"
    t.integer  "balance"
    t.date     "date"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "payments", ["member_id"], :name => "index_payments_on_member_id"

end
