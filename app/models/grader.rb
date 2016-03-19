class Grader < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  has_many :students
  delegate :username, to: :user, allow_nil: true
end
