class Member < ActiveRecord::Base
  attr_accessible :Cell_Number, :Designation, :Email_Address, :First_Name, :Last_Name, :Region, :date, :active, :balance
  has_many :payments
  Designations = ['Judge', 'Magistrate', 'Kadhi']
  Regions = ['Nairobi', 'N. Rift ', 'S. Rift', 'L. Eastern', 'Eastern N', 'N. Eastern', 'N. Nyanza', 'S. Nyanza', 'Embu','Mt. Kenya', 'Kakamega /VHG','Bungoma /Busia', 'Coast']

  scope :judges, where(:Designation => "Judge")
  scope :active, where(:active => true)
  scope :magistrates, where(:Designation => "Magistrate")
  scope :kadhis, where(:Designation => "Kadhi")
  scope :except_judges, where('Designation = "Magistrate" OR Designation = "Kadhi"')
  scope :with_balance, where('balance > 0')


  validates :First_Name, :Last_Name, :Region, :Designation, presence: true
  validates :Email_Address, presence: true



  def self.search(first, last)
    if first.present? && last.present?
      find(:all, :conditions => ["First_Name LIKE ? AND Last_Name LIKE ?", "%#{first}%", "%#{last}%"])
      User.create(:Fisrt_Name => "chege")
    elsif first.present?
      find(:all, :conditions => ["First_Name LIKE ?", "%#{first}%"])
      User.create(:name => "hall")
    elsif last.present?
      find(:all, :conditions => ["Last_Name LIKE ?","%#{last}%"])
      User.create(:name => "mike")
    else
      return nil
    end
  end

  def self.invoice_magistrates
    Member.magistrates.active.includes(:payments).each do | member|
      amount_to_pay = PaymentPlan.last.Magistrate
      member.payments.create(:invoice => amount_to_pay, :amount => amount_to_pay, :balance => 0, :date => Time.now.to_date)
    end
  end

   def self.invoice_kadhis
    Member.kadhis.active.includes(:payments).each do | member|
      amount_to_pay = PaymentPlan.last.Kadhi
      member.payments.create(:invoice => amount_to_pay, :amount => amount_to_pay, :balance => 0, :date => Time.now.to_date)
    end
  end

  def self.invoice_judges
    Member.judges.active.includes(:payments).each do |judge|
      amount_to_pay = PaymentPlan.last.Judge
      balance = judge.payments.last.balance + amount_to_pay
      judge.payments.create(:date => Time.now.beginning_of_year.to_date, :invoice => amount_to_pay, :balance => balance)
      judge.update_attributes(:balance => balance)
    end
  end

  def create_first_invoice
    member = self
    @payment_plan = PaymentPlan.last
    designation = member.Designation
    active = member.active
    if designation == "Judge"
      amount_to_pay =  @payment_plan.Judge
      member.payments.create(:date => Time.now.beginning_of_year.to_date, :invoice => amount_to_pay, :balance => amount_to_pay)
      member.update_attributes(:balance => amount_to_pay)
    elsif designation == "Magistrate" && active == true
      amount_to_pay = @payment_plan.Magistrate
      member.payments.create(:date => Time.now.beginning_of_month.to_date, :invoice => amount_to_pay, :balance => 0, :amount => amount_to_pay)
    elsif designation == "Kadhi" && active == true
      amount_to_pay = @payment_plan.Kadhi
      member.payments.create(:date => Time.now.beginning_of_month.to_date, :invoice => amount_to_pay, :balance => 0, :amount => amount_to_pay)
    end
  end

end
