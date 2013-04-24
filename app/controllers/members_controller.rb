class MembersController < ApplicationController
  
 def search
   @members = Member.paginate(:page => params[:page], :per_page => 20).search(params[:first], params[:last]).order("#{params[:sort]}" + ' ' + "#{params[:direction]}")

   respond_to do |format|
     if @members.present?
       format.html
       format.json { render json: @members }
     else
       format.html {redirect_to members_path, notice: "No results found"}
     end
   end
 end

 def invoice

 end

 def create_invoice
   group = params[:group]
   case group
      when "judges"
        Member.invoice_judges
      when "magistrates"
        Member.invoice_magistrates
      when "kadhis"
        Member.invoice_kadhis
    end
    rescue Exception
      redirect_to invoice_path, notice: 'Invoice failed.'
    else
     redirect_to invoice_path, notice: "#{group} were successfully invoiced"
  end

  # GET /members
  # GET /members.json
  def index
    @members = Member.paginate(:page => params[:page], :per_page => 20).order("#{params[:sort]}" + ' ' + "#{params[:direction]}")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @members }
    end
  end

  # GET /members/1
  # GET /members/1.json
  def show
    @member = Member.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @member }
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
