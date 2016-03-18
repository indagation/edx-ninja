class CreateGraders < ActiveRecord::Migration
  def change
    create_table :graders do |t|
      t.references :user, index: true
      t.references :course, index: true
    end
  end
end
