class AddGoogleTokensToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :google_token, :string, default: nil
    add_column :users, :google_refresh_token, :string, default: nil
  end
end
