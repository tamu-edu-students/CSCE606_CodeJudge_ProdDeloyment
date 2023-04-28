class AddDefaultToRatingInUsers < ActiveRecord::Migration[7.0]
  def change
	change_column :users, :rating, :integer, default: 0
  end
end
