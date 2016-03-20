class AddAcceptingStudentsToGraders < ActiveRecord::Migration
  def change
    add_column :graders, :max_students, :integer, :default => 1    
  end
end
