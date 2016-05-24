class SubmissionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def admin
    if session[:course_id].present?
      @course = Course.find session[:course_id]
    else
      check_for_session
    end
  end
  
  def assignment
    @assignment = Assignment.find(params[:assignment_id])
    @context = "You are viewing %s submissions for the assignment #{@assignment.description}"

    if session[:role_type] == "grader"
      @grader ||= Grader.find session[:role_id]
      @submissions = @grader.submissions.from_assignment(@assignment)
    elsif session[:role_type] == "administrator"
      @submissions = @assignment.submissions
    end

    case params[:status]
    when "unsubmitted"
      @submissions = @submissions.unsubmitted
      @context = @context % "unsubmitted"    
    when "graded"
      @submissions = @submissions.graded
      @context = @context % "the graded"      
    when "ungraded"
      @submissions = @submissions.ungraded
      @context = @context % "the ungraded"      
    else
      @submissions = @submissions
      @context = @context % "all of the"      
    end
    respond_to do |format|
      format.zip { prepare_zip_file }
      format.html { render "search" }
    end
  end

  def show
    @submission = Submission.find(params[:id])
    @assignment = @submission.assignment
    if session[:role_type] == "grader"
      @grader = Grader.find_by :id => session[:role_id]
      @submissions = @grader.submissions.from_assignment(@assignment)
      @students = @grader.students
    elsif session[:role_type] == "administrator"
      @submissions = @assignment.submissions
      @students = @submission.course.students
    end
    if @students.present?
      @students_with_ungraded_submissions = @students.with_ungraded_assignment(@assignment).where.not(:id => @submission.student_id)
      if @students_with_ungraded_submissions.present?
        @next_ungraded_submission = @students_with_ungraded_submissions.first.submissions.from_assignment(@assignment).pluck(:id)
      end
    end
  end

  def unsubmit
    @submission = Submission.find(params[:id])
    @submission.update(:submitted => false, :submitted_at => nil)
    flash.now[:success] = "Submission unsubmitted"
    render "show"
  end
  
  def ungrade
    @submission = Submission.find(params[:id])
    @submission.update(:graded_at => nil)
    flash.now[:success] = "Submission ungraded"
    render "show"
  end

  def edit
    @submission = Submission.find(params[:id])
  end

  def update
    @submission = Submission.find(params[:id])
    if @submission.update_attributes(submission_params)
      flash[:success] = "Assignment updated"
      redirect_to submission_path(@submission)
    else
      flash.now[:danger] = @submission.errors.full_messages[0]
      render "edit"
    end
  end

  def download_student_document
    @submission = Submission.find(params[:id])
    data = open(@submission.student_document.url)
    send_data data.read, filename: @submission.formatted_student_document_file_name, type: "application/pdf"
  end

  def download_grader_document
    @submission = Submission.find(params[:id])
    data = open(@submission.grader_document.url)
    send_data data.read, filename: @submission.grader_document_file_name, type: "application/pdf"
  end

  private
  def prepare_zip_file
    require 'zip'

    #Attachment name
    filename = 'student_documents.zip'
    temp_file = Tempfile.new(filename)
     
    begin
      #This is the tricky part
      #Initialize the temp file as a zip file
      Zip::OutputStream.open(temp_file) do |zos|
        @submissions.each do |submission|
          if submission.student_document.present?
            document_contents = open( submission.student_document.url) {|f| f.read }
            if document_contents.present?
              zos.put_next_entry(submission.student_document_file_name)
              zos.print document_contents                  
            end
          end
        end
      end
     
      #Add files to the zip file as usual
      # Zip::File.open(temp_file.path, Zip::File::CREATE) do |zip|
      #   web_contents = open( @submissions.last.student_document.url) {|f| f.read }
      #   p web_contents
      #   zip.add("submission_file", web_contents.path)
      # end
     
      #Read the binary data from the file
      zip_data = File.read(temp_file.path)
     
      #Send the data to the browser as an attachment
      #We do not send the file directly because it will
      #get deleted before rails actually starts sending it
      send_data(zip_data, :type => 'application/zip', :filename => filename)
    ensure
      #Close and delete the temp file
      temp_file.close
      temp_file.unlink
    end
  end

  # def set_s3_direct_post
  #   @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: '201', acl: 'public-read')
  # end

  def submission_params
    params.require(:submission).permit(:description, :grade, :student_document, :grader_document, :feedback, :mark_submitted, :grade_by_role_id, :grade_by_role_type, :mark_graded)
  end  
end
