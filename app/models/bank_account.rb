class BankAccount < ActiveRecord::Base
  has_many :payments
  attr_accessible :account_name, :account_number, :bank_name, :beneficiary_branch

  Account =[]
  BankAccount.all.each{|x| Account << ["#{x.account_name}" +": "+ "#{x.account_number}", x.id]}
end
