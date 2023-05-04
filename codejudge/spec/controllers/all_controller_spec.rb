require 'rails_helper'

RSpec.describe ProblemsController, type: :controller do
  before(:all) do
    if Problem.where(:title => "Array Sum").empty?
      Problem.create(:title => "Array Sum",
        :body => "this is the array sum problem",
        :languages => Language.find_by(pretty_name: 'C++').id,
        :tags => 1, :difficulty => 7)
    end
    if ProblemTag.where(problem_id: Problem.find_by(:title => "Array Sum").id, tag_id: 1).empty?
      ProblemTag.create(:problem_id => Problem.find_by(title: "Array Sum").id,
        :tag_id => 1)
    end
    if ProblemTag.where(problem_id: Problem.find_by(:title => "Array Sum").id, tag_id: 3).empty?
      ProblemTag.create(:problem_id => Problem.find_by(title: "Array Sum").id,
        :tag_id => 3)
    end
    if ProblemTag.where(problem_id: Problem.find_by(:title => "Array Sum").id, tag_id: 7).empty?
      ProblemTag.create(:problem_id => Problem.find_by(title: "Array Sum").id,
        :tag_id => 7)
    end
    if TestCase.where(problem_id: Problem.find_by(:title => "Array Sum").id).empty?
      TestCase.create(:problem_id => Problem.find_by(title: "Array Sum").id, 
        :input => "", output: "Hello World")

    end

    if Problem.where(:title => "Dynamic Arrays").empty?
      Problem.create(:title => "Dynamic Arrays",
        :body => "this is the dynamic arrays problem",
        :tags => 2,
        :languages => Language.find_by(pretty_name: 'Assembly').id)
    end
    if ProblemTag.where(problem_id: Problem.find_by(:title => "Dynamic Arrays").id, tag_id: 4).empty?
      ProblemTag.create(:problem_id => Problem.find_by(title: "Dynamic Arrays").id,
        :tag_id => 4)
    end
    if ProblemTag.where(problem_id: Problem.find_by(:title => "Dynamic Arrays").id, tag_id: 7).empty?
      ProblemTag.create(:problem_id => Problem.find_by(title: "Dynamic Arrays").id,
        :tag_id => 7)
    end
    if TestCase.where(problem_id: Problem.find_by(:title => "Dynamic Arrays").id).empty?
      TestCase.create(:problem_id => Problem.find_by(title: "Dynamic Arrays").id, 
        :input => "1 2 3", output: "4 5 6")
    end

    if User.where(:username => "instructor").empty?
      User.create(:username => "instructor",
        :email => "instructor@xyz.com", :firstname => "test", :lastname => "test", password: "password", password_confirmation: "password")
      Assignment.create(:user_id => User.find_by(username: "instructor").id,
        :role_id => Role.find_by(name: "instructor").id)
    end
  end
  before(:each) do
    user = User.find_by(username: "instructor")
    allow(controller).to receive(:current_user).and_return(user)
  end

# The following tests are for features added in *** Iteration 2 ***

  describe 'language restriction' do
    it 'checks language attribute in problems table for first problem' do
      problem = Problem.find_by(title: 'Array Sum')
      expect(problem.languages).to eq(Language.find_by(pretty_name: 'C++').id.to_s)
    end
    it 'checks language attribute in problems table for second problem' do
      problem = Problem.find_by(title: 'Dynamic Arrays')
      expect(problem.languages).to eq(Language.find_by(pretty_name: 'Assembly').id.to_s)
    end
  end

  describe 'problem tags' do
    it 'checks tags for the first problem' do
      problem = Problem.find_by(title: 'Array Sum')
      problem_tags = ProblemTag.where(problem_id: problem.id).pluck(:tag_id)
      expect(problem_tags).to include(1)
      expect(problem_tags).to include(3)
      expect(problem_tags).to include(7)
    end
    it 'checks tags for the second problem' do
      problem = Problem.find_by(title: 'Dynamic Arrays')
      problem_tags = ProblemTag.where(problem_id: problem.id).pluck(:tag_id)
      expect(problem_tags).to include(4)
      expect(problem_tags).to include(7)
    end
  end

  describe 'problem creation flow'  do
    it 'does not allow problem creation with duplicate title' do
      previous_size = Problem.count
      post :create, params: { problem: { title: 'Array Sum', body: 'This is the Array Sum problem', language_id: Language.find_by(pretty_name: 'C').id } }
      expect(Problem.count).to eq(previous_size)
    end
    it 'does not allow problem creation with empty title' do
      previous_size = Problem.count
      post :create, params: { problem: { title: '', body: 'This is the Array Sum problem', language_id: Language.find_by(pretty_name: 'C').id } }
      expect(Problem.count).to eq(previous_size)
    end
  end

# The following tests are for features added in *** Iteration 3 ***

  describe 'problem difficulty' do
    it 'diffilculty is 7 for first problem' do
      problem = Problem.find_by(title: 'Array Sum')
      expect(problem.difficulty).to eq(DifficultyLevel.find_by(level: "7").id)
    end
    it 'diffilculty is N/A for second problem' do
      problem = Problem.find_by(title: 'Dynamic Arrays')
      expect(problem.difficulty).to eq(DifficultyLevel.find_by(level: "N/A").id)
    end
  end

end

RSpec.describe AttemptsController, type: :controller do
  before(:all) do
    if User.where(:username => "student1").empty?
      User.create(:username => "student1", :email => "student1@xyz.com", :rating => 1987, :firstname => "test", :lastname => "test", password: "password", password_confirmation: "password")
      Assignment.create(:user_id => User.find_by(username: "student1").id, 
        :role_id => Role.find_by(name: "student").id)
    end
  end
  before(:each) do
    user = User.find_by(username: "student1")
    allow(controller).to receive(:current_user).and_return(user)
  end

# The following tests are for features added in *** Iteration 3 ***

  describe 'dynamic difficulty' do
    it 'check initial difficulty' do
      problem = Problem.find_by(title: "Dynamic Arrays")
      language_id = problem.languages.to_i
      expect(problem.difficulty).to eq(DifficultyLevel.find_by(description: "N/A").id)
    end
    it 'make a submission and check if difficulty changes' do
      problem = Problem.find_by(title: "Dynamic Arrays")
      language_id = problem.languages.to_i
      file = fixture_file_upload('./spec/controllers/test.cpp', 'application/octet-stream')
      post :create, params: { problem_id: problem.id, attempt: { language_list: Language.find_by(id: language_id).pretty_name, sourcecode: file } }
      expect(Problem.find_by(title: "Dynamic Arrays").difficulty).not_to eq(DifficultyLevel.find_by(description: "N/A").id)
    end
  end

# The following tests are for features added in *** Iteration 4 ***

  describe 'check compiler and solution evaluator works' do
    it 'submit a correct solution' do
      problem = Problem.find_by(title: "Array Sum")
      language_id = problem.languages.to_i
      file = fixture_file_upload('./spec/controllers/test.cpp', 'application/octet-stream')
      post :create, params: { problem_id: problem.id, attempt: { language_list: Language.find_by(id: language_id).pretty_name, sourcecode: file } }
      expect(Attempt.where(problem_id: problem.id).first.passed).to eq(true)
    end
    it 'submit a wrong solution' do
      problem = Problem.find_by(title: "Dynamic Arrays")
      language_id = problem.languages.to_i
      file = fixture_file_upload('./spec/controllers/test.cpp', 'application/octet-stream')
      post :create, params: { problem_id: problem.id, attempt: { language_list: Language.find_by(id: language_id).pretty_name, sourcecode: file } }
      expect(Attempt.where(problem_id: problem.id).first.passed).to eq(false)
    end
  end

# The following tests are for features added in *** Iteration 5 ***

  describe 'student rating' do
    it 'check if it is computed according to submissions' do
      previous_rating = User.find_by(username: "student1").rating
      problem = Problem.find_by(title: "Array Sum")
      language_id = problem.languages.to_i
      file = fixture_file_upload('./spec/controllers/test.cpp', 'application/octet-stream')
      post :create, params: { problem_id: problem.id, attempt: { language_list: Language.find_by(id: language_id).pretty_name, sourcecode: file } }
      current_rating = User.find_by(username: "student1").rating
      problem_difficulty = Problem.find_by(title: "Array Sum").difficulty
      expect(current_rating).to eq(previous_rating + 10 * problem_difficulty)
    end
  end
end

RSpec.describe RatingController, type: :controller do

# The following tests are for features added in *** Iteration 5 ***

  describe 'student ranking' do
    it 'check if students are sorted in non-increasing order of rating' do
      get :index, params: {}
      users_w_rating = assigns(:users)
      last_rating = Float::INFINITY
      users_w_rating.each do |user|
        expect(user.rating).not_to be_nil
        expect(user.rating).to be <= last_rating
        last_rating = user.rating
      end
      
      users_rating_na = assigns(:users_rating_na)
      users_rating_na.each do |user|
        expect(user.rating).to be_nil
      end
    end
  end
end