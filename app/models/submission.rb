class Submission < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :student
  serialize :lti_params
  has_one :course, through: :assignment

  has_attached_file :student_document, styles: {thumbnail: "60x60#"}
  validates_attachment :student_document, content_type: { content_type: "application/pdf" }

  delegate :due_date, :due_date_string, :absolute_due_date, :graceperiod, to: :assignment, allow_nil: true

  before_save :identify_student_document

  def identify_student_document
    if student_document_file_name_changed?
      self.student_document.instance_write(:file_name, formatted_student_document_file_name)
    end
  end

  def formatted_student_document_file_name
    "#{self.student.username}-#{self.assignment.description.parameterize}.pdf"
  end

  has_attached_file :grader_document, styles: {thumbnail: "60x60#"}
  validates_attachment :grader_document, content_type: { content_type: "application/pdf" }

  scope :unsubmitted, -> { where.not(:submitted => true) }
  scope :graded, -> { where.not(:graded_at => nil) }
  scope :ungraded, -> { where(:graded_at => nil, :submitted => true) }
  scope :from_assignment, -> (assignment) { joins(:assignment).where(:assignment => assignment) }

  attr_accessor :mark_submitted, :mark_graded, :graded_by_role_id, :graded_by_role_type

  validates :student_document, presence: true, if: "mark_submitted.present?"
  validates :grader_document, presence: true, if: "mark_graded.present?"

  after_save do
    if self.mark_submitted == "1" and self.student_document.exists?
      self.update_column(:submitted, true)
      self.update_column(:submitted_at, Time.now)
    end
    if self.mark_graded == "1" and self.grader_document.exists?
      self.update_column(:graded_at, Time.now)
      self.update_column(:graded_by_id, self.graded_by_grader_id)
      consumer_key = "client-key"
      consumer_secret = "client-secret"
      @provider = IMS::LTI::ToolProvider.new(consumer_key, consumer_secret, self.lti_params)
      p @provider.inspect
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

  def graded_at_string
    if graded_at.present?
      graded_at.strftime("%m/%d/%y %H:%M %Z")
    else
      "Not Graded"
    end
  end

  def submitted_at_string
    if submitted_at.present?
      submitted_at.strftime("%m/%d/%y %H:%M %Z")
    else
      "Not Submitted"
    end
  end

  def past_due?
    if due_date.present?
      absolute_due_date < DateTime.now
    else
      false
    end
  end

  def student_document_button
    if student_document.exists?
      "<a href='#{Rails.application.routes.url_helpers.download_student_document_path(self)}' target='_blank' class='btn btn-primary'>Student PDF</a>"
    else
      "No Student Document"
    end
  end
  def grader_document_button
    if grader_document.exists?
      "<a href='#{Rails.application.routes.url_helpers.download_grader_document_path(self)}' target='_blank' class='btn btn-primary'>Grader PDF</a>"
    else
      "No Grader Document"
    end
  end  
end
