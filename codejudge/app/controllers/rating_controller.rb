class RatingController < ApplicationController
  def index
    student_ids = Assignment.where(role_id: 4).pluck(:user_id)
    @users = User.where(id: student_ids).order(rating: :desc)
  end
end
