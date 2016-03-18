class CreateStaff < ActiveRecord::Migration
  def change
    create_table :staffs do |t|
      t.references :user, index: true      
      t.references :course, index: true      
    end
  end
end
