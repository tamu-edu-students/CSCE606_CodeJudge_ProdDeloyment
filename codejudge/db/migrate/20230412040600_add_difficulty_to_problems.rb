class AddDifficultyToProblems < ActiveRecord::Migration[7.0]
  def change
    add_column :problems, :difficulty, :integer, default: 0
  end
end
