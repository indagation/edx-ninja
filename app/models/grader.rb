class Grader < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  has_many :students
  has_many :submissions, through: :students
  has_many :graded_submissions, :foreign_key => :graded_by_id, :class_name => "Submission"
  delegate :username, to: :user, allow_nil: true

  scope :with_students, -> { includes(:students).where.not(students: { id: nil }) }  
  scope :without_students, -> { includes(:students).where(students: { id: nil }) }  
  scope :with_ungraded_assignments, -> { joins(:submissions).where(submissions: { graded_at: nil, submitted: true }) }  
  scope :accepting_students, ->{ joins('LEFT JOIN "students" ON "students"."grader_id" = "graders"."id"').group('graders.id').having('count(students.id) < graders.max_students') }
end