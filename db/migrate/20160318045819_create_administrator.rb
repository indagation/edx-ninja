class CreateAdministrator < ActiveRecord::Migration
  def change
    create_table :administrators do |t|
      t.references :user, index: true      
      t.references :course, index: true      
    end
  end
end
