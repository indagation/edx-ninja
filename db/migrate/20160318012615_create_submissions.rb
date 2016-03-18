class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.references :assignment, index: true
      t.references :student, index: true

      t.boolean :submitted, index: true, default: false
      t.timestamp :submitted_at

      t.references :graded_by, index: true
      t.decimal :grade, default: 0, :precision => 8, :scale => 8
      t.timestamp :graded_at

      t.text :description
      t.text :lti_params
      t.timestamps
    end
  end
end
