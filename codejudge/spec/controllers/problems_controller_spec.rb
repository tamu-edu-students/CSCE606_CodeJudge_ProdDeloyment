require 'rails_helper'

RSpec.describe ProblemsController, type: :controller do
  before(:all) do
    if Problem.where(:title => "Array Sum").empty?
      Problem.create(:title => "Array Sum",
        :body => "this is the array sum problem",
        :languages => Language.find_by(pretty_name: 'C').id,
        :tags => 1,
        :difficulty => 3)
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

    if Problem.where(:title => "Dynamic Arrays").empty?
      Problem.create(:title => "Dynamic Arrays",
        :body => "this is the dynamic arrays problem",
        :tags => 2,
        :languages => Language.find_by(pretty_name: 'Assembly').id,
        :difficulty => 7)
    end
    if ProblemTag.where(problem_id: Problem.find_by(:title => "Dynamic Arrays").id, tag_id: 4).empty?
      ProblemTag.create(:problem_id => Problem.find_by(title: "Dynamic Arrays").id,
        :tag_id => 4)
    end
    if ProblemTag.where(problem_id: Problem.find_by(:title => "Dynamic Arrays").id, tag_id: 7).empty?
      ProblemTag.create(:problem_id => Problem.find_by(title: "Dynamic Arrays").id,
        :tag_id => 7)
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

  describe 'check problem main page' do
    it 'check the number of problems  on the main page' do
      get :index, params: {}
      expect(assigns(:problems).count).to eq(2) # 2 porblems were added in this test and two problems were added in test db seed
    end
    it 'check if the added problems are present on the main page' do
      get :index, params: {}
      expect(assigns(:problems)).to include(Problem.find_by(title: 'Array Sum'))
      expect(assigns(:problems)).to include(Problem.find_by(title: 'Dynamic Arrays'))
    end
    it 'checks if the particular problem\'s page has all the problem attributes mentioned' do
      problem = Problem.find_by(title: 'Array Sum')
      get :index, params: {id: problem.id}
      expect(assigns(:problems)).to include(problem)
      expect(problem.title).to eq("Array Sum")
      expect(problem.body).to eq("this is the array sum problem")
      expect(problem.languages).to eq("4")
    end
  end

  describe 'check show problem page' do 
    it 'check the problem attributes' do
      problem = Problem.find_by(title: 'Array Sum')
      get :show, params: {id: problem.id}
      expect(assigns(:problem)).to eq(problem)
      expect(assigns(:problem).title).to eq(problem.title)
      expect(assigns(:problem).body).to eq(problem.body)
    end
    it 'check language restriction' do
      problem = Problem.find_by(title: 'Array Sum')
      get :show, params: {id: problem.id}
      expect(assigns(:languages_list)).to eq(Language.where(id: problem.languages).pluck(:pretty_name))
    end
  end

  describe 'check if problem tag is present' do
    it 'check if it returns the problem tag' do
      problem = Problem.find_by(title: "Array Sum")
      expect(ProblemTag.where(problem_id: problem.id)).to exist
    end
  end

  describe 'edit button check' do
    it 'edit the language restriction and expect it to change' do
      problem = Problem.find_by(title: 'Array Sum')
      expect(ProblemTag.where(problem_id: problem.id)).to exist
      new_languages = Language.find_by(pretty_name: 'COBOL').id
      allow(controller).to receive(:tag_params).and_return(problem.tags)
      put :update, params: { id: problem.id, problem: { languages: new_languages } }
      expect(Problem.find(problem.id).languages).to eq(new_languages.to_s)
    end
    it 'edit the tags and expect it to change' do
      problem = Problem.find_by(title: 'Array Sum')
      expect(ProblemTag.where(problem_id: problem.id)).to exist
      new_tags = 7
      allow(controller).to receive(:tag_params).and_return(new_tags)
      put :update, params: { id: problem.id, problem: { tags: new_tags } }
      expect(ProblemTag.find(problem.id).tag_id).to eq(new_tags)
    end
  end

  describe 'delete and check if problem is present' do
    it 'delete the problem and expect it to be absent in the db and from the main page' do
      problem = Problem.find_by(title: 'Array Sum')
      delete :destroy, params: {id: problem.id}
      get :index, params: {}
      expect(assigns(:problems).count).to eq(1)
      expect(Problem.where(title: "Array Sum")).not_to exist
    end
  end

  describe 'Multiple problem tags' do
    it 'check the problem tags for each problem on the main page' do
      expect(ProblemTag.where(problem_id: Problem.find_by(title: 'Array Sum').id, tag_id: 1)).to exist
      expect(ProblemTag.where(problem_id: Problem.find_by(title: 'Array Sum').id, tag_id: 3)).to exist
      expect(ProblemTag.where(problem_id: Problem.find_by(title: 'Array Sum').id, tag_id: 7)).to exist

      expect(ProblemTag.where(problem_id: Problem.find_by(title: 'Dynamic Arrays').id, tag_id: 4)).to exist
      expect(ProblemTag.where(problem_id: Problem.find_by(title: 'Dynamic Arrays').id, tag_id: 7)).to exist

    end
  end

end

RSpec.describe RatingController, type: :controller do
  before(:all) do
    if User.where(:username => "instructor").empty?
      User.create(:username => "instructor",
        :email => "instructor@xyz.com")
      Assignment.create(:user_id => User.find_by(username: "instructor").id,
        :role_id => Role.find_by(name: "instructor").id)
    end

    if User.where(:username => "student1").empty?
      User.create(:username => "student1", :email => "student1@xyz.com", :rating => 1987, :firstname => "test", :lastname => "test", password: "password", password_confirmation: "password")
      Assignment.create(:user_id => User.find_by(username: "student1").id, 
        :role_id => Role.find_by(name: "student").id)
    end

    if User.where(:username => "student2").empty?
      User.create(:username => "student2", :email => "student2@xyz.com", :rating => 2139, :firstname => "test", :lastname => "test", password: "password", password_confirmation: "password")
      Assignment.create(:user_id => User.find_by(username: "student2").id, 
        :role_id => Role.find_by(name: "student").id)
    end
  end

  describe 'check student ranking' do
    it 'check students are ranked in non-increasing order of their rating' do
      get :index, params: {}
      expect(assigns(:users)).not_to include(User.find_by(username: "instructor"))
      expect(assigns(:users)[0]).to eq(User.find_by(username: "student2"))
      expect(assigns(:users)[1]).to eq(User.find_by(username: "student1"))
    end
  end
end

RSpec.describe UsersController, type: :controller do
  before(:all) do
    if User.where(:username => "student1").empty?
      User.create(:username => "student1", :email => "student1@xyz.com", :rating => 1987, :firstname => "test", :lastname => "test", password: "password", password_confirmation: "password")
      Assignment.create(:user_id => User.find_by(username: "student1").id, 
        :role_id => Role.find_by(name: "student").id)
    end

    if User.where(:username => "student2").empty?
      User.create(:username => "student2", :email => "student2@xyz.com", :rating => 2139, :firstname => "test", :lastname => "test", password: "password", password_confirmation: "password")
      Assignment.create(:user_id => User.find_by(username: "student2").id, 
        :role_id => Role.find_by(name: "student").id)
    end
  end

  describe 'show user page' do
    it 'check we are getting the same user from the show user page' do
      user = User.find_by(username: "student1")
      get :show, params: {id: user.id}
      expect(assigns(:show_user)).to eq(user)
    end
  end
end