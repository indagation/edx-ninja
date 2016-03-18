class Submission < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :student
  serialize :lti_params

  has_attached_file :student_document, styles: {thumbnail: "60x60#"}
  validates_attachment :student_document, content_type: { content_type: "application/pdf" }

  has_attached_file :grader_document, styles: {thumbnail: "60x60#"}
  validates_attachment :grader_document, content_type: { content_type: "application/pdf" }
end
