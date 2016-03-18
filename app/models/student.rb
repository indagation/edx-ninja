class Student < ActiveRecord::Base
  belongs_to :course
  belongs_to :user
  belongs_to :grader
  has_many :submissions
  delegate :username, to: :user

  scope :no_grader, -> { where(:grader_id => nil) }
  scope :has_grader, -> { where.not(:grader_id => nil) }
end
