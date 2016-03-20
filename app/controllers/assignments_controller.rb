class AssignmentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    if request.method == "POST"
      set_provider_info
      if @provider.resource_link_id.present?
        @resource_link_id = @provider.resource_link_id.split('-')[1]

        if @resource_link_id.present? and @course.present?
          @assignment = Assignment.find_or_create_by :resource_link_id => @resource_link_id, :course => @course
        end
      end
    elsif params[:id].present?
      @assignment = Assignment.find(params[:id])
    end

    if @assignment.present?
      if session[:role_type] == "student"
        @student ||= Student.find session[:role_id]        
        @submission = Submission.find_by :student => @student, :assignment => @assignment
        unless @submission.present?
          @submission = Submission.create :student => @student, :assignment => @assignment, :lti_params => params
        end
        render "submissions/show"
      elsif session[:role_type] == "grader"
        @grader ||= Grader.find session[:role_id]
        @context = "You are viewing submissions for the assignment: #{@assignment.resource_link_id}"
        @submissions = @grader.submissions
        render "submissions/index"
      elsif session[:role_type] == "administrator"
        @context = "You are viewing submissions for the assignment: #{@assignment.resource_link_id}"
        @submissions = @assignment.submissions
        render "submissions/index"
      end
    end
  end      
end
