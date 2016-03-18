class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.references :user, index: true      
      t.references :course, index: true
      t.references :grader, index: true            
    end
  end
end
