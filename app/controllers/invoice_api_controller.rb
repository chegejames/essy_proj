class InvoiceApiController < ApplicationController
  skip_before_filter :authenticate_user!
  def invoice
    @status = Member.invoice_members_from_api(params[:ids])
  end
end
