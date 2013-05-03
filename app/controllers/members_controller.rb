class MembersController < ApplicationController
 load_and_authorize_resource :except => [:judges_with_balances]
  def deleted_members
  end
  def judges_with_balances
    @search = Member.judges.with_balance.search(params[:q])
    @members = @search.result.paginate(:page => params[:page], :per_page => 20).order("id ASC")
  end
  def invoice

  end

  def create_invoice
    group = params[:group]
    count = 0
    case group
    when "judges"
      count = Member.invoice_judges
    when "magistrates"
      count = Member.invoice_magistrates
    when "kadhis"
      count = Member.invoice_kadhis
    end
  rescue Exception
    redirect_to invoice_path, notice: 'Invoice failed.'
  else
    redirect_to invoice_path, notice: "#{count} #{group} successfully invoiced"
  end

  # GET /members
  # GET /members.json
  def index
    @search = Member.search(params[:q])
    @members_pdf= Member.search(params[:q]).result
    @members = @search.result.paginate(:page => params[:page], :per_page => 20).order("id ASC")



    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @members }
      format.pdf do
        render :pdf => "All_members",
      end
    end
  end

  # GET /members/1
  # GET /members/1.json
  def show
    @member = Member.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @member }
      format.pdf do
        render :pdf => "#{@member.first_name}_#{@member.last_name}",
      end
    end
  end

  # GET /members/new
  # GET /members/new.json
  def new
    @member = Member.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @member }
    end
  end

  # GET /members/1/edit
  def edit
    @member = Member.find(params[:id])
    unauthorized! if cannot? :update, @member
  end

  # POST /members
  # POST /members.json
  def create
    @member = Member.new(params[:member])

    respond_to do |format|
      if @member.save
        @member.create_first_invoice
        format.html { redirect_to @member, notice: 'Member was successfully created.' }
        format.json { render json: @member, status: :created, location: @member }
      else
        format.html { render action: "new" }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /members/1
  # PUT /members/1.json
  def update
    @member = Member.find(params[:id])

    respond_to do |format|
      if @member.update_attributes(params[:member])
        format.html { redirect_to @member, notice: 'Member was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @member = Member.find(params[:id])
    @member.destroy

    respond_to do |format|
      format.html { redirect_to members_url }
      format.json { head :no_content }
    end
  end
end
