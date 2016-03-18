class SubmissionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def edit
    @submission = Submission.find(params[:id])
    if session[:role_type] == "student"
      render "edit_student"
    elsif session[:role_type] == "grader" or session[:role_type] == "administrator"
      render "edit_grader"
    end
  end

  def update
    @submission = Submission.find(params[:id])
    if @submission.update_attributes(submission_params)
      consumer_key = "client-key"
      consumer_secret = "client-secret"
      @provider = IMS::LTI::ToolProvider.new(consumer_key, consumer_secret, @submission.lti_params)
      response = @provider.post_replace_result!(@submission.grade)
      flash[:notice] = "Assignment updated"
    else
      @message = "Submssion issue"
    end
    redirect_to assignment_path(@submission.assignment)
  end
  private

  def submission_params
    params.require(:submission).permit(:description, :grade, :student_document, :grader_document)
  end  
end
