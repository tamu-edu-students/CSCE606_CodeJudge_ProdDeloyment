class AddForeignKeyToProblemTag < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :problem_tags, :difficulty_levels, column: :difficulty_level_id
  end
end
