class InvoiceController < ApplicationController
  def index

  end

  def create_invoice
    @group = params[:group]
    case @group
    when "judges"
      @count, @already_paid, @deactivated = Member.invoice_judges
    when "magistrates"
      @count, @already_paid, @deactivated = Member.invoice_magistrates
    when "kadhis"
      @count, @already_paid, @deactivated = Member.invoice_kadhis
    end

  rescue Exception
    redirect_to invoice_index_path, notice: 'Invoice failed.'

  else

    #render :partial => "create_invoice" if request.xhr?
    respond_to do |format|
      format.html #"#{count} #{group} successfully invoiced  #{"and " + already_paid.to_s + " had already paid" if already_paid > 0}"}
    end
    #render :partial => 'cases', :object => @cases, :content_type => 'text/html'
    #redirect_to invoice_index_path,
  end


end
