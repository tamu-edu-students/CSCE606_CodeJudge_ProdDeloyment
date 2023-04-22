class Problem < ApplicationRecord
  has_many :test_cases, dependent: :destroy
  accepts_nested_attributes_for :test_cases, reject_if: :all_blank, allow_destroy: true
  has_many :attempts
  # has_many :attempts, dependent: :destroy
  has_many :problem_tags, dependent: :destroy
  accepts_nested_attributes_for :problem_tags, reject_if: :all_blank, allow_destroy: true
  def visible_test_cases(problem, role)
    role == :student.to_s ? problem.test_cases.where(example: true) : problem.test_cases
  end

  filterrific(
    default_filter_params: { with_tag_id: nil },
    available_filters: [
      :with_tag_id,
      :with_difficulty_id
    ]
  )
  scope :with_tag_id, ->(tag_id) {
    # Filters students with any of the given country_ids
    # where(tags: tag_id )
    joins(:problem_tags).where(problem_tags: { tag_id: tag_id })
  }
  scope :with_difficulty_id, ->(difficulty_id) {
    # Filters students with any of the given country_ids
    # where(tags: tag_id )
    where(difficulty: difficulty_id)
  }

end
