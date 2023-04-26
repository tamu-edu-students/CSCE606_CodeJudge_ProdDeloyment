class ChangeDefaultDifficultyInProblems < ActiveRecord::Migration[6.1]
  def change
    change_column_default :problems, :difficulty, 11
  end
end

