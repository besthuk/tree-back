class GroupUserRequestsController < ApplicationController
  before_action :set_group_user_request, only: [:show, :edit, :update, :destroy]

  # GET /group_user_requests
  # GET /group_user_requests.json
  def index
    @group_user_requests = GroupUserRequest.all
  end

  # GET /group_user_requests/1
  # GET /group_user_requests/1.json
  def show
  end

  # GET /group_user_requests/new
  def new
    @group_user_request = GroupUserRequest.new
  end

  # GET /group_user_requests/1/edit
  def edit
  end

  # POST /group_user_requests
  # POST /group_user_requests.json
  def create
    @group_user_request = GroupUserRequest.new(group_user_request_params)

    respond_to do |format|
      if @group_user_request.save
        format.html { redirect_to @group_user_request, notice: 'Group user request was successfully created.' }
        format.json { render :show, status: :created, location: @group_user_request }
      else
        format.html { render :new }
        format.json { render json: @group_user_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /group_user_requests/1
  # PATCH/PUT /group_user_requests/1.json
  def update
    respond_to do |format|
      if @group_user_request.update(group_user_request_params)
        format.html { redirect_to @group_user_request, notice: 'Group user request was successfully updated.' }
        format.json { render :show, status: :ok, location: @group_user_request }
      else
        format.html { render :edit }
        format.json { render json: @group_user_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /group_user_requests/1
  # DELETE /group_user_requests/1.json
  def destroy
    @group_user_request.destroy
    respond_to do |format|
      format.html { redirect_to group_user_requests_url, notice: 'Group user request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group_user_request
      @group_user_request = GroupUserRequest.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def group_user_request_params
      params.fetch(:group_user_request, {})
    end
end
