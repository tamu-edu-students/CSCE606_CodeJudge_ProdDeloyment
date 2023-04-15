class RemoveDifficultyLevelIdFromProblemTags < ActiveRecord::Migration[7.0]
  def change
    remove_column :problem_tags, :difficulty_level_id, :integer
  end
end
