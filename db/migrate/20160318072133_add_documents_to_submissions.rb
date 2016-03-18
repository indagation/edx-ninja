class AddDocumentsToSubmissions < ActiveRecord::Migration
  def up
    add_attachment :submissions, :student_document
    add_attachment :submissions, :grader_document
  end

  def down
    remove_attachment :submissions, :student_document
    remove_attachment :submissions, :grader_document
  end
end
