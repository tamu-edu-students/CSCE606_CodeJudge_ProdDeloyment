class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
    authorize :user, :index?
  end

  # GET /users/1 or /users/1.json
  def show
    # @user_roles = @user.roles.map{|role| role.name}
    # authorize :user
    @show_user = User.find(params[:id])
    @show_roles = Role.where(id: Assignment.where(user_id: params[:id]).pluck(:role_id)).pluck(:name).join(" / ")
    @show_attempts = Attempt.where(user_id: params[:id])

    @map_tags = Hash.new

    for prb in Problem.all do
      results = ActiveRecord::Base.connection.execute("
        SELECT tags.tag
        FROM problem_tags
        JOIN tags ON problem_tags.tag_id = tags.id
        WHERE problem_tags.problem_id = #{prb.id}")
      tag_list = results.map { |row| row['tag'] }
      if tag_list.length == 0
        tag_list[0] = "No Tag Specified"
      end
      tag_list = tag_list.join(', ')
      @map_tags.store(prb.id, tag_list)
    end
  end

  # GET /users/new
  def new
    @user = User.new
    authorize @user
  end

  # GET /users/1/edit
  def edit
    @all_roles = Role.all
    @assigned_roles = @user.roles
    authorize :user
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    authorize @user

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    authorize :user
    p params[:user]
    params[:user].delete(:password) if params[:user][:password].blank?
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    authorize @user
    
    ############################ Deleting user assignments ############################
    Assignment.where(user_id: @user.id).destroy_all
    
    ############################ Deleting user from groups ############################
    StudentGroup.where(user_id: @user.id).destroy_all

    ############################ Deleting user attempts ############################
    attempt_ids = Attempt.where(user_id: @user.id).pluck(:id)
    Score.where(attempt_id: attempt_ids).destroy_all
    Attempt.where(id: attempt_ids).destroy_all

    ############################ Deleting authored problems ############################

    authored_problems = Problem.where(author_id: @user.id).pluck(:id)

    # delete dependent problem tags
    ProblemTag.where(problem_id: authored_problems).destroy_all

    # delete dependent problem groups
    ProblemGroup.where(problem_id: authored_problems).destroy_all

    # delete dependent problem attempts
    attempt_ids = Attempt.where(problem_id: authored_problems).pluck(:id)
    Score.where(attempt_id: attempt_ids).destroy_all
    Attempt.where(id: attempt_ids).destroy_all

    # delete dependent problem test cases
    test_case_ids = TestCase.where(problem_id: authored_problems).pluck(:id)
    Score.where(test_case_id: test_case_ids).destroy_all
    TestCase.where(id: test_case_ids).destroy_all

    Problem.where(id: authored_problems).destroy_all


    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:firstname, :lastname, :username, :email, role_ids: [])
    end
end
