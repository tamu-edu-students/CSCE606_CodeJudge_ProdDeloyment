class Group < ApplicationRecord
  has_many :student_groups, dependent: :nullify
end