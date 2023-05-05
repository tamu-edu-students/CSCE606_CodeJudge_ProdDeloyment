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
    p "herebro"
    @problem = @attempt.problem
    p @attempt.id
    @graded_test_cases = Score.all.where(attempt_id: @attempt.id)
    p @graded_test_cases
    @error = nil
    @graded_test_cases_io = []
    # p @graded_test_cases[0][:stderr]
    if @graded_test_cases.present? && @graded_test_cases[0][:stderr].present?
      # @grad_test_len = 1
      @error = @graded_test_cases[0][:stderr]
      p "working!!!!!!!!"
    else
      test_case_ids = @graded_test_cases.pluck(:test_case_id)
      graded_tc = TestCase.all.where(id: test_case_ids)
      graded_tc.each do |test_case|
        # do something with test_case
        # @graded_test_cases_io << [test_case[:input], test_case[:output]]
        p "fix_here"
        @graded_test_cases_io << [test_case[:input], test_case[:output]] if test_case.present?

      end
    end
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
    code_extension = File.extname(params[:attempt][:sourcecode])
    code_language = Language.find_by(extension: code_extension)
    if code_language.nil?
      notice_message = "File Extension not supported"
    elsif language.id != code_language.id
      notice_message = "Language Restriction is enforced. Submit in " + language.name
    end
      if code_language and (language.id == code_language.id or language.name == "none")

      @attempt.code = File.read(params[:attempt][:sourcecode])

      @attempt.user_id = session[:user_id]
      if @attempt.user_id.nil?
        @attempt.user_id = current_user.id
      end
      @attempt.problem_id = params[:problem_id]
      @attempt.language_id = code_language.id
      @attempt.save
      @testcases_query = TestCase.left_outer_joins(:problem).where(problem_id: @attempt.problem_id).map{ |r| [r.input, r.output]}
      puts @testcases_query
      api_timeout = 1
      result = true
      error = nil
      p "failing"
      if @testcases_query.nil?
        p "nil brp"
      end
      @testcases_query.each_with_index do |item, index|
        timeout = index*api_timeout
        results = SubmitCodeJob.perform(item[0], item[1], code_language.name, @attempt.code, @testcases_query.index(item), current_user.id, @attempt.id)
        puts results
        puts "working"
        result = result && results[:passed]
        error = results[:stderr]
      end
      @attempt.passed = result
      respond_to do |format|
        if @attempt.save
          correct_submissions = Attempt.where(problem_id: @attempt.problem_id, passed: true).distinct.count(:user_id)
          all_submissions = Attempt.where(problem_id: @attempt.problem_id).distinct.count(:user_id)
          problem = Problem.find_by(id: params[:problem_id])
          previous_difficulty = problem.difficulty

          correct_ratio = correct_submissions.to_f / all_submissions
          difficulty = case correct_ratio
            when 0..0.1 then 10
            when 0.1..0.2 then 9
            when 0.2..0.3 then 8
            when 0.3..0.4 then 7
            when 0.4..0.5 then 6
            when 0.5..0.6 then 5
            when 0.6..0.7 then 4
            when 0.7..0.8 then 3
            when 0.8..0.9 then 2
            else 1
          end

          problem.update(difficulty: difficulty)

          if Attempt.where(user_id: @attempt.user_id, problem_id: @attempt.problem_id, passed: true).count == 1
            # first attempt for this problem
            user = User.where(id: @attempt.user_id).first
            new_rating = user.rating.nil? ? 0 : user.rating
            if previous_difficulty != 11
              new_rating += 10 * previous_difficulty
            end
            user.update(rating: new_rating)
            end
          if(previous_difficulty != difficulty)
            users = User.joins(:attempts).where(attempts: { problem_id: @attempt.problem_id, passed: true }).distinct
            users.each do |user|
              new_rating = user.rating
              if previous_difficulty != 11
                new_rating -= 10 * previous_difficulty
              end
              if difficulty != 11
                new_rating += 10 * difficulty
              end
              user.update(rating: new_rating)
            end
          end


          format.html do
            if error.present?
              redirect_to attempt_url(@attempt)
              flash[:error] =  "Compilation Error"
            elsif result
              redirect_to attempt_url(@attempt)
              flash[:notice] =  "All test cases passed"
            else
              redirect_to attempt_url(@attempt)
              flash[:error] = "Test cases failed"
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
        flash[:error] = "Problem already in list!"
        format.html { redirect_to request.referer || root_path, status: :unprocessable_entity, notice: notice_message}
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
