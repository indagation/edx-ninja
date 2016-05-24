class AddDisplayNameToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :display_name, :text
    add_column :assignments, :due_date, :datetime
    add_column :assignments, :graceperiod, :integer
  end
end