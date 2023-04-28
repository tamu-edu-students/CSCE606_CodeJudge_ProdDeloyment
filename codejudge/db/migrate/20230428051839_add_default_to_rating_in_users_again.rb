class AddDefaultToRatingInUsersAgain < ActiveRecord::Migration[7.0]
  def change
	change_column :users, :rating, :integer, default: nil
  end
end
