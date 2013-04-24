class PaymentPlan < ActiveRecord::Base
  attr_accessible :judge, :kadhi, :magistrate
  validates :judge, :kadhi, :magistrate, presence: true, numericality: true
end
