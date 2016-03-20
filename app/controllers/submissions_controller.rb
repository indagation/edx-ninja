class SubmissionsController < ApplicationController
  skip_before_action :verify_authenticity_token

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
    render "search"
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
  def submission_params
    params.require(:submission).permit(:description, :grade, :student_document, :grader_document, :feedback, :mark_submitted, :grade_by_role_id, :grade_by_role_type, :mark_graded)
  end  
end
