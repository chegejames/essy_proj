class Member < ActiveRecord::Base
  attr_accessible :cell_number, :designation, :email_address, :first_name, :last_name, :region, :date, :active, :balance
  has_many :payments, :dependent => :destroy
  Designations = ['Judge', 'Magistrate', 'Kadhi']
  Regions = ['Nairobi', 'N. Rift ', 'S. Rift', 'L. Eastern', 'Eastern N', 'N. Eastern', 'N. Nyanza', 'S. Nyanza', 'Embu','Mt. Kenya', 'Kakamega /VHG','Bungoma /Busia', 'Coast']

 # include ActiveModel::Dirty
  after_update :create_first_invoice, :if => :has_been_activated?
  scope :judges, where(:designation => "Judge")
  scope :active, where(:active => true)
  scope :magistrates, where(:designation => "Magistrate")
  scope :kadhis, where(:designation => "Kadhi")
  scope :except_judges, where('designation = "Magistrate" OR designation = "Kadhi"')
  scope :with_balance, where('balance > 0')


  validates :first_name, :last_name, :region, :designation, presence: true
  validates :email_address, presence: true, uniqueness: true, format: {with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/}


  def ever_active?
    self.balance.present?
  end

  def has_been_activated?
    if self.ever_active? == false
      self.active_changed?
    end
  end


  def self.invoice_magistrates
    Member.magistrates.active.includes(:payments).each do | member|
      amount_to_pay = PaymentPlan.last.magistrate
      member.payments.create(:invoice => amount_to_pay, :amount => amount_to_pay, :balance => 0, :date => Time.now.to_date)
    end
  end

   def self.invoice_kadhis
    Member.kadhis.active.includes(:payments).each do | member|
      amount_to_pay = PaymentPlan.last.kadhi
      member.payments.create(:invoice => amount_to_pay, :amount => amount_to_pay, :balance => 0, :date => Time.now.to_date)
    end
  end

  def self.invoice_judges
    Member.judges.active.includes(:payments).each do |judge|
      amount_to_pay = PaymentPlan.last.judge
      balance = judge.payments.last.balance + amount_to_pay
      judge.payments.create!(:date => Time.now.beginning_of_year.to_date, :invoice => amount_to_pay, :amount => 0, :balance => balance)
      judge.update_attributes(:balance => balance)
    end
  end

  def create_first_invoice
    member = self
    @payment_plan = PaymentPlan.last
    designation = member.designation
    active = member.active
    if designation == "Judge" && active == true
      amount_to_pay =  @payment_plan.judge
      member.payments.create(:date => Time.now.beginning_of_year.to_date, :amount => 0, :invoice => amount_to_pay, :balance => amount_to_pay)
      member.update_attributes(:balance => amount_to_pay)
    elsif designation == "Magistrate" && active == true
      amount_to_pay = @payment_plan.magistrate
      member.payments.create(:date => Time.now.beginning_of_month.to_date, :invoice => amount_to_pay, :balance => 0, :amount => amount_to_pay)
      memeber.update_attributes(:balance => 0)
    elsif designation == "Kadhi" && active == true
      amount_to_pay = @payment_plan.kadhi
      member.payments.create(:date => Time.now.beginning_of_month.to_date, :invoice => amount_to_pay, :balance => 0, :amount => amount_to_pay)
      member.update_attributes(:balance => 0)
    end
  end

end
