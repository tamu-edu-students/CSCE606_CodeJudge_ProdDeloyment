class AddRatingToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :rating, :integer,  default: 0
  end
end
