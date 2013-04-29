class Payment < ActiveRecord::Base
  belongs_to :member
  attr_accessible :amount, :balance, :bank_name, :cheque_no, :mode_of_payment, :total_amount, :invoice, :date, :region
  validates :amount, presence: true, numericality: true, allow_blank: true
  validates :bank_name, :cheque_no, presence: true, if => :paid_with_cheque?
  Payment_modes = ['cash', 'cheque']
  #after_save :update_member_balance

  def paid_with_cheque?
    mode_of_payment == "cheque"
  end

  def get_balance
    payment = self
    @balance = payment.member.payments.last.balance
    payment.balance = (@balance - payment.amount)
  end

  def update_balance
    payment = self
    @balance = payment.member.payments[-2].balance
    @balance = (@balance - payment.amount)
    payment.update_attributes(:balance => @balance)
  end

  def update_member_balance
    member = self.member
    balance = self.balance
    member.update_attributes(:balance => balance)
  end
end
