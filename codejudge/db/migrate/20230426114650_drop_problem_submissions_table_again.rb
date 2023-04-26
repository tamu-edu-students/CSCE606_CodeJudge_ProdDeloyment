class DropProblemSubmissionsTableAgain < ActiveRecord::Migration[7.0]
  def change
    drop_table :problem_submissions
  end
end
