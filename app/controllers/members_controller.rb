class MembersController < ApplicationController
 load_and_authorize_resource :except => [:judges_with_balances]

  def deleted_members
    @search = Member.only_deleted.search(params[:q])
    @members = @search.result.paginate(:page => params[:page], :per_page => 20)
  end

  def judges_with_balances
    if params[:q].present?
      params[:q]["payments_date_gteq(2i)"] = "1"
      params[:q]["payments_date_gteq(3i)"] = "1"
      @search = Member.judges.search(params[:q])
      @result = @search.result.uniq
      @members, @total_balance = Member.get_balances_as_of_dates(@result, params[:q])
      @members_pdf = @members
      @with_search_terms = true
    else
      @with_search_terms = false
      @search = Member.judges.with_balance.search(params[:q])
      @members_pdf = @search.result.order("id ASC")
      @members = @search.result.paginate(:page => params[:page], :per_page => 20).order("id ASC")
      @total_balance = @members.sum(:balance)
    end


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @members }
      format.pdf do
        render :pdf => "judges with balances",
      end
    end
  end



# GET /members
# GET /members.json
  def index
    @search = Member.search(params[:q])
    @members_pdf= @search.result.order("id ASC")
    @members = @search.result.paginate(:page => params[:page], :per_page => 20).order("id ASC")



    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @members }
      format.pdf do
        render :pdf => "members",
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
