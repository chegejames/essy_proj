class AdminController < ApplicationController
  def index
    @members = Member.paginate(:page => params[:page], :per_page => 20).judges.with_balance.paginate(:page => params[:page], :per_page => 20).
                              order("#{params[:sort]}" + ' ' + "#{params[:direction]}")
  end

  def all_payments
    @payments = Payment.paginate(:page => params[:page], :per_page => 20)
  end
end
