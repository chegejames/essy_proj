class Member < ActiveRecord::Base
  attr_accessible :Cell_Number, :Designation, :Email_Address, :First_Name, :Last_Name, :Region, :date, :active
  has_many :payments
  Designations = ['Judge', 'Magistrate', 'Kadhi']
  Regions = ['Central', 'Easter', 'Western']

  scope :judges, where(:Designation => "Judge")
  scope :magistrates, where(:Designatin => "Magistrate")
  scope :kadhis, where(:Designation => "Kadhi")

end
