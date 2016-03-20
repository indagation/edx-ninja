class Submission < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :student
  serialize :lti_params

  has_attached_file :student_document, styles: {thumbnail: "60x60#"}
  validates_attachment :student_document, content_type: { content_type: "application/pdf" }

  has_attached_file :grader_document, styles: {thumbnail: "60x60#"}
  validates_attachment :grader_document, content_type: { content_type: "application/pdf" }

  scope :unsubmitted, -> { where.not(:submitted => true) }
  scope :graded, -> { where.not(:graded_at => nil) }
  scope :ungraded, -> { where(:graded_at => nil, :submitted => true) }
  scope :from_assignment, -> (assignment) { joins(:assignment).where(:assignment => assignment) }

  attr_accessor :mark_submitted, :mark_graded, :graded_by_role_id, :graded_by_role_type
  
  after_save do
    if self.mark_submitted == "1"
      self.update_column(:submitted, true)
      self.update_column(:submitted_at, Time.now)
    end
    if self.mark_graded == "1" or self.graded_at.present?
      self.update_column(:graded_at, Time.now)
      self.update_column(:graded_by_id, self.graded_by_grader_id)
      consumer_key = "client-key"
      consumer_secret = "client-secret"
      @provider = IMS::LTI::ToolProvider.new(consumer_key, consumer_secret, self.lti_params)
      response = @provider.post_replace_result!(self.grade)      
    end
  end

  def graded_by_grader_id
    if self.graded_by_role_id.present? and self.graded_by_role_type.present? and self.graded_by_role_type == "grader"
      self.graded_by_role_id
    else
      0
    end
  end

  def graded_by
    Grader.find_by(:id => self.graded_by_id)
  end

  def graded_by_username
    if graded_by.present?
      graded_by.username
    else
      "admin"
    end
  end
end
