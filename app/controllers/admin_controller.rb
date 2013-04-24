class AdminController < ApplicationController
  def index
    @members = Member.judges.with_balance
  end

  def all_payments
    @payments = Payment.all
  end
end
