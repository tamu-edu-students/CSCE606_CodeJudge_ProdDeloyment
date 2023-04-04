class ProblemsController < ApplicationController
  before_action :set_problem, only: %i[ show edit update destroy ]

  before_action :set_languages

  helper_method :submit_button_modal, :get_problem

  # GET /problems or /problems.json
  def index
    @difficulty_levels = DifficultyLevel.all
    puts @difficulty_levels
    @tags = Tag.all
    @languages = Language.all
    @problems = Problem.all
    @map = Hash.new
    @map_level = Hash.new
    for prb in @problems do
      tag_name = Tag.where(id: prb.tags).pick(:tag)
      level_name = DifficultyLevel.where(id: prb.level).pick(:level)
      @map.store(prb.id, tag_name)
      @map_level.store(prb.id, level_name)
    end
    render :index
  end

  # GET /problems/1 or /problems/1.json
  def show
    @languages_list = Language.where(id: @problem.languages).pluck(:pretty_name)
    @attempt = Attempt.new
    @visible_test_cases = @problem.visible_test_cases @problem, current_user.role
    @no_test_cases_prompt = current_user.role?(:student) ? "No example Test Cases provided." : "No Test Cases were specified for that Problem."
  end

  def searchtag
    # puts search_tag_params
    @problems = Problem.where(tags: search_tag_params)
    @tag_name = Tag.where(id: search_tag_params).pick(:tag)
  end

  def searchlevel
    puts "level!!"
    puts search_level_params
    @problems = Problem.where(level: search_level_params)
    @level_name = DifficultyLevel.where(id: search_level_params).pick(:level)
    puts @level_name
  end

  def solution_upload
    @problem = Problem.where(id: params[:problem_id])
    puts @problem.inspect
    @user_id = session[:user_id]
    language = Language.where(pretty_name: params[:language]).pick(:name)
    language_id = Language.where(name: language).pick(:id)
    @solution_code = File.read(params[:solution_sourcecode])
    @language_id = language_id
    @testcases_query = TestCase.left_outer_joins(:problem).where(problem_id: @problem.first.id).map{ |r| [r.input, r.output]}
    api_timeout = 1
    passed = true;
    @testcases_query.each_with_index do |item, index|
      timeout = index*api_timeout
      @results = perform_instructor_solution(item[0], item[1], language, @solution_code, @testcases_query.index(item), current_user.id, 46)
      puts @results.inspect
      if !@results[:passed]
        passed = false;
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
    # if flash[:warning].present?
    #   @error_message = flash[:warning]
    #   flash[:warning] = nil
    # else
    #   @error_message = nil
    #   if @error_message.present?
    #   end
    # end

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
    authorize :problem
    # @tags = Tag.all
  end

  # POST /problems or /problems.json
  def create
    @problem = Problem.new(problem_params)
    @problem_tag = ProblemTag.new
    @problem_level = DifficultyLevel.new
    @problem_tag.tag_id = tag_params
    @problem_tag.difficulty_level_id = level_params
    authorize @problem
    puts "entering in create"
   
    puts "Reaced create #################################"

   if @problem.title.empty?
      flash[:notice] = "The title cannot be nil."
      redirect_to new_problem_path
    
    else
      problem = Problem.find_by('lower(title) = ?', params[:problem][:title].downcase)
      if problem.present?
        flash[:warning] = "Problem already in list!"
        redirect_to request.referer
      
      else
        respond_to do |format|
          if @problem.save
            @problem_tag.problem_id = @problem.id
            if @problem_tag.save!
              format.html { redirect_to problem_url(@problem), notice: "Problem was successfully created." }
              format.json { render :show, status: :created, location: @problem }
            end
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
    authorize :problem
    @tags = Tag.all
    id = @problem.id
    @problem_tag = ProblemTag.where(problem_id: id).first
    # puts @problem_tag.inspect
    @problem_tag.tag_id = tag_params
    @problem_tag.difficulty_level_id = level_params
    @problem_tag.save
    if @problem.update(problem_params)
      redirect_to problems_path
    end
  end

  # DELETE /problems/1 or /problems/1.json
  def destroy
    authorize @problem
    
    @problem.destroy

    respond_to do |format|
      format.html { redirect_to problems_url, notice: "Problem was successfully destroyed." }
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
      params.require(:problem).permit(:title, :body, :tags, :level, :languages,  test_cases_attributes: [:id, :input, :output, :example, :_destroy])
    end

    def tag_params
      params[:problem][:tags]
    end

    def level_params
      params[:problem][:level]
    end

    def search_tag_params
      params[:search_tag]
    end
    def search_level_params
      params[:search_level]
      # puts search_level
    end

    def set_languages
      @languages = ['Bash', 'C++', 'Python']
    end
end
