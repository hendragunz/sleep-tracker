class AddAccessTokenToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :authentication_token, :string
    add_column :users, :authentication_token_created_at, :datetime
  end
end
