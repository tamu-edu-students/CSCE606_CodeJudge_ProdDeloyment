class ProblemTag < ApplicationRecord
  belongs_to :problem
  # has_many :problem_tags, :through => :tags
end
