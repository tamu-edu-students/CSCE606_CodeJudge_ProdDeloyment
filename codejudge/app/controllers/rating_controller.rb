class RatingController < ApplicationController
  def index
    student_ids = Assignment.where(role_id: Role.find_by(name: "student").id).pluck(:user_id)
    @users = User.where(id: student_ids).where.not(rating: [nil]).order(rating: :desc)
    @users_rating_na = User.where(id: student_ids).where(rating: [nil])
  end
end
