class AddFeedbackToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :feedback, :text
  end
end
