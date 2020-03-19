class GroupUsersController < ApplicationController
  before_action :set_group_user, only: [:show, :edit, :update, :destroy]

  # GET /group_users
  # GET /group_users.json
  def index
    @group_users = GroupUser.all
  end

  # GET /group_users/1
  # GET /group_users/1.json
  def show
  end

  # GET /group_users/new
  def new
    @group_user = GroupUser.new
  end

  # GET /group_users/1/edit
  def edit
  end

  # POST /group_users
  # POST /group_users.json
  def create
    @group_user = GroupUser.new(group_user_params)

    respond_to do |format|
      if @group_user.save
        format.html { redirect_to @group_user, notice: 'Group user was successfully created.' }
        format.json { render :show, status: :created, location: @group_user }
      else
        format.html { render :new }
        format.json { render json: @group_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /group_users/1
  # PATCH/PUT /group_users/1.json
  def update
    respond_to do |format|
      if @group_user.update(group_user_params)
        format.html { redirect_to @group_user, notice: 'Group user was successfully updated.' }
        format.json { render :show, status: :ok, location: @group_user }
      else
        format.html { render :edit }
        format.json { render json: @group_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /group_users/1
  # DELETE /group_users/1.json
  def destroy
    @group_user.destroy
    respond_to do |format|
      format.html { redirect_to group_users_url, notice: 'Group user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group_user
      @group_user = GroupUser.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def group_user_params
      params.fetch(:group_user, {})
    end
end
