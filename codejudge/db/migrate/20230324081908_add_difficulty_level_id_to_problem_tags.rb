class AddDifficultyLevelIdToProblemTags < ActiveRecord::Migration[7.0]
  def change
    add_column :problem_tags, :difficulty_level_id, :bigint
  end
end
