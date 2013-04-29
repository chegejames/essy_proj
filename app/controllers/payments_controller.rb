class PaymentsController < ApplicationController
  load_and_authorize_resource :except => [:all_payments, :index, :show]
  def all_payments
    @search = Payment.search(params[:q])
    @payments = @search.result.paginate(:page => params[:page], :per_page => 20)
    @amount = @payments.sum(:amount)
    @invoice = @payments.sum(:invoice)
    @five_percent = @amount * 0.005

  end
  # GET /payments
  # GET /payments.json
  def index
    @member = Member.find(params[:member_id])
    @payments = @member.payments.reverse!.paginate(:page => params[:page], :per_page => 20)
    @last_12_payments = @payments.last(12)
    @invoice = @payments.sum(:invoice)
    @amount = @payments.sum(:amount)
    @balance = @invoice - @amount

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @payments }
      format.pdf do
        render :pdf => "#{@member.first_name}_#{@member.last_name}",
               :header => {:html => { :template => "payments/header.pdf.erb"}}
      end
    end
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
    @member = Member.find(params[:member_id])
    @payments = @member.payments
    @payment = Payment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @payment }
      format.pdf do
        render :pdf => "#{@member.first_name}_#{@member.last_name}",
               :header => {:html => { :template => "payments/header.pdf.erb"}}

      end
    end
  end

  # GET /payments/new
  # GET /payments/new.json
  def new
    @member = Member.find(params[:member_id])
    @payment = Payment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @payment }
    end
  end

  # GET /payments/1/edit
  def edit
    @member = Member.find(params[:member_id])
    @payment = Payment.find(params[:id])
  end

  # POST /payments
  # POST /payments.json
  def create
    @member = Member.find(params[:member_id])
    @payment = @member.payments.build(params[:payment])
    @payment.region = @member.region
    @payment.get_balance

    respond_to do |format|
      if @payment.save
        @payment.update_member_balance

        format.html { redirect_to [@member, @payment], notice: 'Payment was successfully created.' }
        format.json { render json: @payment, status: :created, location: @payment }
      else
        format.html { render action: "new" }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /payments/1
  # PUT /payments/1.json
  #FIXME not updating again!!!!!
  def update
    @member = Member.find(params[:member_id])
    @payment = Payment.find(params[:id])

    respond_to do |format|
      if @payment.update_attributes(params[:payment])
        @payment.update_balance
        @payment.update_member_balance
        format.html { redirect_to [@member, @payment], notice: 'Payment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @member = Member.find(params[:member_id])
    @payment = Payment.find(params[:id])
    @payment.destroy

    respond_to do |format|
      format.html { redirect_to member_payments_path(@member) }
      format.json { head :no_content }
    end
  end
end
