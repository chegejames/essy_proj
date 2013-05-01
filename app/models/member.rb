class Member < ActiveRecord::Base
  attr_accessible :designation, :first_name, :last_name, :region, :date, :active, :balance
  has_many :payments, :dependent => :destroy
  Designations = ['Judge', 'Magistrate', 'Kadhi']
  Regions = ['Nairobi', 'N. Rift ', 'S. Rift', 'L. Eastern', 'Eastern N', 'N. Eastern', 'N. Nyanza', 'S. Nyanza', 'Embu','Mt. Kenya', 'Kakamega /VHG','Bungoma /Busia', 'Coast']
  default_scope order('id DESC')
  after_update :create_first_invoice, :if => :has_been_reactivated?
  after_update :create_first_invoice, :if => :designation_has_changed?
  before_update :create_first_invoice, :if => :has_been_activated?

  scope :judges, where(:designation => "Judge")
  scope :active, where(:active => true)
  scope :magistrates, where(:designation => "Magistrate")
  scope :kadhis, where(:designation => "Kadhi")
  scope :except_judges, where('designation = "Magistrate" OR designation = "Kadhi"')
  scope :with_balance, where('balance > 0')


  validates :first_name, :last_name, :designation, presence: true, format: {with: /^[a-zA-Z.'-,\s]+$/}


  def months_to_end_of_year
    Time.now.end_of_year.month - Time.now.prev_month.month
  end

  def ever_active?
    self.balance.present?
  end

  def has_been_activated?
    unless self.ever_active?
      self.active_changed?
    end
  end

  def has_been_reactivated?
    if self.ever_active?
      self.active_changed?
    end
  end

  def designation_has_changed?
    if self.ever_active?
      self.designation_changed?
    end
  end


  def self.invoice_magistrates
    count = 0
    Member.magistrates.active.includes(:payments).each do | magistrate|
      unless magistrate.payments.last.date.this_month?
        count += 1
        amount_to_pay = PaymentPlan.last.magistrate
        magistrate.payments.create(:invoice => amount_to_pay, :amount => amount_to_pay, :balance => 0, :date => Time.now.to_date, :region => magistrate.region)
      end
    end
    return count
  end

  def self.invoice_kadhis
    count = 0
    Member.kadhis.active.includes(:payments).each do | kadhi|
      unless kadhi.payments.last.date.this_month?
        count += 1
        amount_to_pay = PaymentPlan.last.kadhi
        kadhi.payments.create(:invoice => amount_to_pay, :amount => amount_to_pay, :balance => 0, :date => Time.now.to_date, :region => kadhi.region)
      end
    end
    return count
  end

  def self.invoice_judges
    count = 0
    Member.judges.active.includes(:payments).each do |judge|
      last_payment =  judge.payments.last
      unless last_payment.date.this_year?
        count += 1
        amount_to_pay = PaymentPlan.last.judge
        balance = last_payment.balance + amount_to_pay
        judge.payments.create!(:date => Time.now.beginning_of_year.to_date, :invoice => amount_to_pay, :amount => 0, :balance => balance, :region => judge.region)
        judge.update_column(:balance => balance)
      end
    end
    return count
  end

  def create_first_invoice
    member = self
    @payment_plan = PaymentPlan.last
    designation = member.designation
    active = member.active
    if designation == "Judge" && active
      unless member.payments.present?
        date =  Time.now.beginning_of_year.to_date
        amount_to_pay =  @payment_plan.judge
        balance = amount_to_pay
      else
        date = Time.now.beginning_of_month.to_date
        amount_to_pay = (@payment_plan.judge/12) * months_to_end_of_year
        balance = member.balance + amount_to_pay
      end
      member.payments.create(:date => date, :amount => 0, :invoice => amount_to_pay, :balance => balance, :region => member.region)
      member.update_column(:balance, balance)
    elsif designation == "Magistrate" && active
      amount_to_pay = @payment_plan.magistrate
      unless member.payments.present?
        balance = 0
      else
        balance = member.balance
      end
      member.payments.create(:date => Time.now.beginning_of_month.to_date, :invoice => amount_to_pay, :balance => balance, :amount => amount_to_pay, :region => member.region)
      member.update_column(:balance,  balance)
    elsif designation == "Kadhi" && active
      amount_to_pay = @payment_plan.kadhi
      unless member.payments.present?
        balance =0
      else
        balance = member.balance
      end
      member.payments.create(:date => Time.now.beginning_of_month.to_date, :invoice => amount_to_pay, :balance => balance, :amount => amount_to_pay, :region => member.region)
      member.update_column(:balance, balance)
    end
  end

end
