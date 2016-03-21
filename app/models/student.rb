class Student < ActiveRecord::Base
  belongs_to :course
  belongs_to :user
  belongs_to :grader
  has_many :submissions
  delegate :username, :email, to: :user, allow_nil: true

  scope :no_grader, -> { where(:grader_id => nil) }
  scope :has_grader, -> { where.not(:grader_id => nil) }
  scope :with_ungraded_assignments, -> { joins(:submissions).where(submissions: { graded_at: nil, submitted: true }) }   
end
