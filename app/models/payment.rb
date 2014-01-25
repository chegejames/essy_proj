class Payment < ActiveRecord::Base
  belongs_to :member
  belongs_to :bank_account

  acts_as_paranoid
  attr_accessible :amount, :balance, :bank_name, :cheque_no, :mode_of_payment, :total_amount, :invoice, :date, :region, :bank_account_id
  validates :amount, presence: true, numericality: true, allow_blank: true
  validates :cheque_no, presence: true, :if => :paid_with_cheque?
  validates  :cheque_no, :length => {:is => 0}, :if => :paid_with_cash?
  Payment_modes = ['cash', 'cheque']

  scope :with_balance, where('balance > 0')

  def paid_with_cheque?
    mode_of_payment == "cheque"
  end

  def paid_with_cash?
    mode_of_payment == "cash"
  end

  def get_balance
    payment = self
    @balance = payment.member.payments.last.balance
    payment.balance = (@balance - payment.amount)
  end
  #FIXME editing balance makes it negative or sth like that.
  #FIXME when all payments are deleted balance should be set to zero
  def update_balance
    payment = self
    @balance = payment.member.payments.sum(:invoice) - payment.member.payments.sum(:amount)
   # @balance = (@balance - payment.amount)
    payment.update_attributes(:balance => @balance)
  end

  def update_member_balance
    member = self.member
    balance = self.balance
    member.update_attributes(:balance => balance)
  end

  def not_paid_this_month?
    self.date.strftime("%B %Y") !=  Date.today.strftime("%B %Y")
  end

  def not_paid_this_year?
    self.date.strftime("%Y") !=  Date.today.strftime("%Y")
  end
end
