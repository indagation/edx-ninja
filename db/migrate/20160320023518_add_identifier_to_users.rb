class AddIdentifierToUsers < ActiveRecord::Migration
  def change
    add_column :users, :identifier, :text, index: true
  end
end
