class AddUsernameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string, default: nil    
  end
end
