class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.references :course, index: true
      t.string :resource_link_id, index: true
    end
  end
end
