class ProblemsController < ApplicationController
  before_action :set_problem, only: %i[ show edit update destroy ]

  before_action :set_languages

  helper_method :submit_button_modal, :get_problem

  # GET /problems or /problems.json
  def index
    @user_id = session[:user_id]
    @filterrific = initialize_filterrific(
      Problem,
      params[:filterrific],
      select_options: {
        # sorted_by: Problem.options_for_sorted_by,
        with_tag_id: Tag.options_for_select,
        with_difficulty_id: DifficultyLevel.options_for_select,
        # with_submission: ["solved", "unsolved", "wrong"]
      },
      persistence_id: "shared_key",
      default_filter_params: {},
      available_filters: [
        :with_tag_id, 
        :with_difficulty_id 
        # :with_submission
      ],
      sanitize_params: true,
    ) || return

    puts "here"
    @map_tags = Hash.new
    p params[:filterrific]
    puts "exiting"
    # @filterrific.filter_
    # if params[:filterrific].present?
    #   @problems = @filterrific.find
    #                           .with_submission(params[:filterrific][:with_submission], @user_id)
    #                           .with_tag_id(params[:filterrific][:with_tag_id])
    #                           .with_difficulty_id(params[:filterrific][:with_difficulty_id])
    #                           .paginate(page: params[:page], per_page: 10)
    # else
    @problems = @filterrific.find.page(params[:page])
    # end
    # @problems = @filterrific.find.with_tag_id(params[:filterrific][:with_tag_id]).with_difficulty_id(params[:filterrific][:with_difficulty_id]).paginate(page: params[:page], per_page: 10)


    for prb in @problems do
      # problem_tags = Tag.joins(:ProblemTag).where(problem_tags: { problem_id: prb.id }).pluck(:tag)
      # puts(problem_tags)
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
      @map_tags.store(prb.id, tag_list)
    end

    @map_attempted = Hash.new
    @map_passed = Hash.new

    Attempt.where(user_id: @user_id).each do |attempt|
      @map_attempted.store(attempt.problem_id, "true")
      @map_passed.store(attempt.problem_id, "true") if attempt.passed.to_s == "true"
    end
    
    respond_to do |format|
      format.html
      format.js
    end
    # render :index
    # puts "end"

  end

  # GET /problems/1 or /problems/1.json
  def show
    @languages_list = Language.where(id: @problem.languages).pluck(:pretty_name)
    @attempt = Attempt.new
    @solution_exists = Attempt.exists?(user_id: session[:user_id], problem_id: @problem.id, passed: true)
    @visible_test_cases = @problem.visible_test_cases @problem, current_user.role
    @no_test_cases_prompt = current_user.role?(:student) ? "No example Test Cases provided." : "No Test Cases were specified for that Problem."
    results = ActiveRecord::Base.connection.execute("
        SELECT tags.tag
        FROM problem_tags
        JOIN tags ON problem_tags.tag_id = tags.id
        WHERE problem_tags.problem_id = #{@problem.id}")
    @tag_list = results.map { |row| row['tag'] }
    if @tag_list.length == 0
      @tag_list[0] = "No Tag Specified"
    end
    @tag_list = @tag_list.join(', ')
  end

  # def searchtag
  #   # puts search_tag_params
  #   @problems = Problem.where(tags: search_tag_params)
  #   @tag_name = Tag.where(id: search_tag_params).pick(:tag)
  # end


  def solution_upload
    @problem = Problem.where(id: params[:problem_id])
    puts @problem.inspect
    @user_id = session[:user_id]

    # language = Language.where(pretty_name: params[:language]).pick(:name)
    # language_id = Language.where(name: language).pick(:id)
    @solution_code = File.read(params[:solution_sourcecode])
    code_extension = File.extname(params[:solution_sourcecode])
    language = Language.find_by(extension: code_extension)
    # @language_id = language_id
    @testcases_query = TestCase.left_outer_joins(:problem).where(problem_id: @problem.first.id).map{ |r| [r.input, r.output]}
    api_timeout = 1
    passed = true
    @testcases_query.each_with_index do |item, index|
      timeout = index*api_timeout
      @results = perform_instructor_solution(item[0], item[1], language.name, @solution_code, @testcases_query.index(item), current_user.id, 46)
      puts @results.inspect
      if !@results[:passed]
        passed = false
      end
    end
    if passed
      @problem.first.instructor_solution = @solution_code
      @problem.first.save
      redirect_back(fallback_location: root_path)
    else
      puts "Failed to save solution"
    end
  end

  def submit_button_modal(*args)
    @problem_temp = args[0]
    @return_var
    if(@problem_temp.instructor_solution)
      @return_var = "Edit Solution"
    else
      @return_var = "Submit Solution"
    end
    return @return_var
  end

  def solution
    id  = params[:id]
  end

  def get_problem(*args)
    @id = args[0]
    @problem = Problem.where(id: @id).first
    #return @Problem
  end

  # GET /problems/new
  def new
    @tags = Tag.all
    @problem = Problem.new
    @languages = Language.all
    @difficulty_levels = DifficultyLevel.all
    authorize @problem
    # @test_cases = @problem.test_cases
  end

  # GET /problems/1/edit
  def edit
    @problem = Problem.find params[:id]
    @tags = Tag.all
    @languages = Language.all
    @difficulty_levels = DifficultyLevel.all

    results = ActiveRecord::Base.connection.execute("
        SELECT tags.id
        FROM problem_tags
        JOIN tags ON problem_tags.tag_id = tags.id
        WHERE problem_tags.problem_id = #{@problem.id}")
    @tag_list = results.map { |row| row['id'] }
    authorize @problem
    # @tags = Tag.all
  end

  # POST /problems or /problems.json
  def create
    @problem = Problem.new(problem_params)
    @problem.author_id = session[:user_id]
    # @problem_tag = ProblemTag.new
    # @problem_level = DifficultyLevel.new
    # @problem_tag.tag_id = tag_params
    authorize @problem
    puts "entering in create"

    puts "Reaced create #################################"

    if @problem.title.empty?
      flash[:error] = "The title cannot be nil."
      redirect_to new_problem_path
    else
      problem = Problem.find_by('lower(title) = ?', params[:problem][:title].downcase)
      if problem.present?
        flash[:error] = "Problem already in list!"
        redirect_to request.referer
      else
        respond_to do |format|
          if @problem.save
            # @problem_tag.problem_id = @problem.id
            # if @problem_tag.save!
              flash[:success] = "Problem was successfully created"
              format.html { redirect_to problem_url(@problem)}
              format.json { render :show, status: :created, location: @problem }
            # end
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @problem.errors, status: :unprocessable_entity }
          end
        end
      end
    end
  end

  # PATCH/PUT /problems/1 or /problems/1.json
  def update
    authorize @problem
    # @tags = Tag.all
    # id = @problem.id
    # @problem_tag = ProblemTag.where(problem_id: id).first
    # @problem_tag.tag_id = tag_params

    # @problem_tag.save

    if @problem.update(problem_params)
      flash[:success] = "Problem was updated successfully"
      redirect_to problems_path
    end
  end

  # DELETE /problems/1 or /problems/1.json
  def destroy
    authorize @problem

    ProblemGroup.where(problem_id: @problem.id).destroy_all
    ProblemTag.where(problem_id: @problem.id).destroy_all
    Attempt.where(problem_id: @problem.id).destroy_all

    @problem.destroy

    respond_to do |format|
      flash[:success] = "Problem was successfully destroyed."
      format.html { redirect_to problems_url}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_problem
      @problem = Problem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def problem_params
      params.require(:problem).permit(:title, :body, :difficulty, :languages, problem_tags_attributes: [:id, :tag_id, :_destroy], test_cases_attributes: [:id, :input, :output, :example, :_destroy], )
    end

    def tag_params
      params[:problem][:tags]
    end

    def search_tag_params
      params[:search_tag]
    end

    def set_languages
      @languages = ['Bash', 'C++', 'Python']
    end
  end