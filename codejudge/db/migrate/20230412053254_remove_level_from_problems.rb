class RemoveLevelFromProblems < ActiveRecord::Migration[6.1]
  def change
    remove_column :problems, :level
  end
end

