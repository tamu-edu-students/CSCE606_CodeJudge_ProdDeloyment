class AddLevelsToProblems < ActiveRecord::Migration[7.0]
  def change
    add_column :problems, :level, :string
  end
end
