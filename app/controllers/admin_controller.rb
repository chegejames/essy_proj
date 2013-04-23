class AdminController < ApplicationController
  def index
    @payments = Payment.all
  end
end
