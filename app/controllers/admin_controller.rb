class AdminController < ApplicationController
  def index
    @search = Member.paginate(:page => params[:page], :per_page => 20).judges.with_balance.search(params[:q])
    @members = @search.result
  end

  def all_payments
    @search = Payment.search(params[:q])
    @payments = @search.result.paginate(:page => params[:page], :per_page => 20)
  end

  def home
  end
end
