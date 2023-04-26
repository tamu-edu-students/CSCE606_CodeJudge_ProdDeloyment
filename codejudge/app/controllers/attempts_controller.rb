class AttemptsController < ApplicationController

  require 'rest-client'
  require 'pygments'
  before_action :set_attempt, only: %i[ show edit update destroy ]
  helper_method :get_net_score
  # GET /attempts or /attempts.json
  def index
    unless current_user.role? :admin
      @attempts = current_user.attempts
    else
      @attempts = Attempt.all
    end

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

  # GET /attempts/1 or /attempts/1.json
  def show
    @problem = @attempt.problem
    @graded_test_cases = Score.all.where(attempt_id: @attempt.id)
    @number_graded_test_cases = @graded_test_cases.length
    @number_ungraded_test_cases = @problem.test_cases.length - @graded_test_cases.length
  end

  # GET /attempts/new
  def new
    @attempt = Attempt.new

  end

  # GET /attempts/1/edit
  def edit
  end


  # POST /attempts or /attempts.json
# This function pulls the test cases for the problem and sends it off to Sidekiq
  def create
    puts "here2"
    @attempt = Attempt.new
    language = Language.find_by(pretty_name: params[:attempt][:language_list])

    if language
      language_id = language.id

      @attempt.code = File.read(params[:attempt][:sourcecode])
      @attempt.user_id = session[:user_id]
      @attempt.problem_id = params[:problem_id]
      @attempt.language_id = language_id
      @attempt.save
      @testcases_query = TestCase.left_outer_joins(:problem).where(problem_id: @attempt.problem_id).map{ |r| [r.input, r.output]}
      puts @testcases_query
      api_timeout = 1
      result = true
      @testcases_query.each_with_index do |item, index|
        timeout = index*api_timeout
        results = SubmitCodeJob.perform(item[0], item[1], language.name, @attempt.code, @testcases_query.index(item), current_user.id, @attempt.id)
        puts results
        puts "working"
        result = result && results[:passed]
      end
      @attempt.passed = result
      respond_to do |format|
        if @attempt.save
          correct_submissions = Attempt.where(user_id: @attempt.user_id, problem_id: @attempt.problem_id, passed: true).count
          all_submissions = Attempt.where(user_id: @attempt.user_id, problem_id: @attempt.problem_id).count
          problem = Problem.find_by(id: params[:problem_id])

          if all_submissions < 5
            difficulty = 11
          else
            correct_ratio = correct_submissions.to_f / all_submissions
            difficulty = case correct_ratio
              when 0..0.05 then 10
              when 0.05..0.1 then 9
              when 0.1..0.15 then 8
              when 0.15..0.2 then 7
              when 0.2..0.25 then 6
              when 0.25..0.3 then 5
              when 0.3..0.35 then 4
              when 0.35..0.4 then 3
              when 0.4..0.45 then 2
              else 1
            end
          end

          problem.update(difficulty: difficulty)

          format.html do
            if result
              redirect_to attempt_url(@attempt), notice: "All Test Cases are passed"
            else
              redirect_to attempt_url(@attempt), notice: "Test Cases Failed"
            end
          end
          format.json { render :show, status: :created, location: @attempt }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @attempt.errors, status: :unprocessable_entity }
        end
      end
    else
      puts "here"
      # handle the case when the language is nil
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { error: "Language not found" }, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /attempts/1 or /attempts/1.json
  def update
    respond_to do |format|
      if @attempt.update(attempt_params)
        format.html { redirect_to attempt_url(@attempt), notice: "Attempt was successfully updated." }
        format.json { render :show, status: :ok, location: @attempt }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @attempt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attempts/1 or /attempts/1.json
  def destroy
    @attempt.destroy

    respond_to do |format|
      format.html { redirect_to attempts_url, notice: "Attempt was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def get_net_score(*args)
    attemptId = args[0]
    @currentAttempt = Attempt.where(id: attemptId).first
    @pb = @currentAttempt.problem
    @tests = @pb.test_cases.length
    @graded_tests = Score.all.where(attempt_id: attemptId)
    @number_Of_graded_test_cases = @graded_tests.length
    @number_Of_ungraded_test_cases = @tests - @graded_tests.length
    if @number_Of_ungraded_test_cases > 0
       @net_score = "Grading In Progress"
    else
       @s = 0
       @graded_tests.each_with_index do |item, index|
         if(item.passed)
           @s = @s + 1
         end
       end
       @netScore = "#{@s}" + "/" + "#{@tests}"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attempt
      @attempt = Attempt.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def attempt_params
      params.require(:attempt).permit(:code)
    end
end
