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
    @context = "You are viewing %s submissions for the assignment #{@assignment.resource_link_id}"

    case params[:status]
    when "unsubmitted"
      @submissions = @assignment.submissions.unsubmitted
      @context = @context % "unsubmitted"    
    when "graded"
      @submissions = @assignment.submissions.graded
      @context = @context % "the graded"      
    when "ungraded"
      @submissions = @assignment.submissions.ungraded
      @context = @context % "the ungraded"      
    else
      @submissions = @assignment.submissions
      @context = @context % "all of the"      
    end
    respond_to do |format|
      format.zip { prepare_zip_file }
      format.html {render "search"}
    end
  end

  def show
    @submission = Submission.find(params[:id])
  end

  def unsubmit
    @submission = Submission.find(params[:id])
    @submission.update(:submitted => false, :submitted_at => nil)
    flash.now[:success] = "Submission unsubmitted"
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

  def submission_params
    params.require(:submission).permit(:description, :grade, :student_document, :grader_document, :feedback, :mark_submitted, :grade_by_role_id, :grade_by_role_type, :mark_graded)
  end  
end
