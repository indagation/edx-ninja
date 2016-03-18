class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :context_id, index: true
      t.string :name    
    end
  end
end
