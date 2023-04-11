require 'rails_helper'

RSpec.describe ProblemGroupsController, type: :controller do
  before(:all) do
    if Problem.where(:title => "Array Sum").empty?
      Problem.create(:title => "Array Sum",
        :body => "this is the array sum problem",
        :tags => 1,
        :languages => Language.find_by(pretty_name: 'C').id)
    end
    if Problem.where(:title => "Dynamic Arrays").empty?
      Problem.create(:title => "Dynamic Arrays",
        :body => "this is the dynamic arrays problem",
        :tags => 2,
        :languages => Language.find_by(pretty_name: 'Assembly').id)
    end
    if User.where(:username => "instructor").empty?
      User.create(:username => "instructor",
        :email => "instructor@xyz.com")
      Assignment.create(:user_id => User.find_by(username: "instructor").id,
        :role_id => Role.find_by(name: "instructor").id)
    end
    if Group.where(:group_title => "software engineering").empty?
      Group.create(:group_title => "software engineering", 
        :description => "description of swe group")
    end
    if ProblemGroup.where(group_id: Group.find_by(group_title: "software engineering").id).empty?
      ProblemGroup.create(group_id: Group.find_by(group_title: "software engineering").id, 
        :problem_id => Problem.find_by(title: "Array Sum").id)
    end
  end
  before(:each) do
    user = User.find_by(username: "instructor")
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'check if problem group pair already exists' do
    it 'check for a flash warning' do
      post :add_problem_form, params: { group_id: Group.find_by(group_title: "software engineering").id, problem_title: "Array Sum" }
      expect(flash[:warning]).to eq("Problem already in list!")
    end
  end

  describe 'check problem group pair gets added' do
    it 'add a new problem to existing group' do
      expect(ProblemGroup.where(group_id: Group.find_by(group_title: "software engineering").id, problem_id: Problem.find_by(title: "Dynamic Arrays").id)).not_to exist
      post :add_problem_form, params: { group_id: Group.find_by(group_title: "software engineering").id, problem_title: "Dynamic Arrays" }
      expect(flash[:success]).to eq("Problem added successfully!")
      expect(ProblemGroup.where(group_id: Group.find_by(group_title: "software engineering").id, problem_id: Problem.find_by(title: "Dynamic Arrays").id)).to exist
    end
  end

end