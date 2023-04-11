class CreateProblemSubmissions < ActiveRecord::Migration[6.1]
  def change
    create_table :problem_submissions do |t|
      t.string :user_id
      t.string :problem_id
      t.integer :total_attempts, default: 0
      t.integer :correct_attempts, default: 0
      t.integer :wrong_attempts, default: 0
      t.integer :compilation_failures, default: 0
      t.integer :time_limits_exceeded, default: 0

      t.timestamps
    end

    add_index :problem_submissions, [:user_id, :problem_id], unique: true
  end
end

