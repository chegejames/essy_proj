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

ActiveRecord::Schema.define(:version => 20130424001102) do

  create_table "members", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "designation"
    t.string   "email_address"
    t.string   "cell_number"
    t.string   "region"
    t.boolean  "active"
    t.integer  "balance"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "payment_plans", :force => true do |t|
    t.integer  "judge"
    t.integer  "magistrate"
    t.integer  "kadhi"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "payments", :force => true do |t|
    t.integer  "member_id"
    t.string   "region"
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

  create_table "searches", :force => true do |t|
    t.string   "designation"
    t.string   "region"
    t.boolean  "active"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end
