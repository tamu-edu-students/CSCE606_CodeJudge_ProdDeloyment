class GroupsController < ApplicationController
  before_action :set_group, only: %i[ show edit update destroy ]
  helper_method :get_users_of_group, :get_problems_of_group, :get_group_id, :get_tags_of_problems, :get_class
  # GET /groups or /groups.json
  def index
    @groups = Group.where(author_id: cookies.signed[:user_id])
    @student_groups = StudentGroup.all
    @users = User.all
    @problems = Problem.all
    @problem_group = ProblemGroup.all
  end

  # GET /groups/1 or /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
    @group.author_id ||= cookies.signed[:user_id]
  end

  # GET /groups/1/edit
  def edit
  end

  def details()
    id = params[:id]
  end

  # POST /groups or /groups.json
  def create
    puts "generatecode"
    puts generate_activation_code
    classcode = group_params.extract!(:classcode)
    puts "in create"
    puts classcode
    @group = Group.new(group_params)
    @group.classcode = generate_activation_code

      if @group.save
        flash[:success] = "Class group was successfully created."
        redirect_to instructors_path
      end
  end

  # PATCH/PUT /groups/1 or /groups/1.json
  def update
    
      if @group.update(group_params)
        flash[:success] = "Class group was successfully updated."
        redirect_to instructors_path
      end
  end

  # DELETE /groups/1 or /groups/1.json
  def destroy
    ProblemGroup.where(group_id: @group.id).destroy_all
    @group.destroy
    respond_to do |format|
      flash[:success] = "Class group was successfully destroyed."
      format.html { redirect_to instructors_path, notice: "class group was successfully destroyed." }
      format.json { head :no_content }
    end
#     if @group.destroy
#       redirect_to instructors_path
#     end
  end

  def get_users_of_group
    student_group_mappings = StudentGroup.where(group_id: params[:id])
  end

  def get_problems_of_group
    problem_group_mappings = ProblemGroup.where(group_id: params[:id])
  end

  def get_tags_of_problems(prb)
    results = ActiveRecord::Base.connection.execute("
        SELECT tags.tag
        FROM problem_tags
        JOIN tags ON problem_tags.tag_id = tags.id
        WHERE problem_tags.problem_id = #{prb.id}")
    tag_list = results.map { |row| row['tag'] }
    if tag_list.length == 0
      tag_list[0] = "No Tag Specified"
    end

    tag_name = Tag.where(id: ProblemTag.where(problem_id: prb.id).pick(:tag_id)).pick(:tag)
    level_name = DifficultyLevel.where(id: prb.difficulty).pick(:level)
    tag_list = tag_list.join(', ')
  end

  def get_group_id
    group_id = params[:id]
  end

  def get_class
    @group_description = Group.where(id: get_group_id)[0]
  end

  def generate_activation_code(size = 6)
    charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
    (0...size).map{ charset.to_a[rand(charset.size)] }.join
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def group_params
      params.require(:group).permit(:author_id, :group_title, :description, :classcode)
    end
end
