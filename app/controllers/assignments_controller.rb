class AssignmentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def admin
    if session[:course_id].present?
      @course = Course.find session[:course_id]
    else
      check_for_session
    end
  end
  
  def show
    if request.method == "POST"
      set_provider_info
      if @provider.resource_link_id.present?
        @resource_link_id = @provider.resource_link_id.split('-')[1]

        if @resource_link_id.present? and @course.present?
          @assignment = Assignment.find_or_create_by :resource_link_id => @resource_link_id, :course => @course
        end
        if @assignment.present?
          if params[:custom_component_due_date].present?
            begin
              @due_date = DateTime.parse(params[:custom_component_due_date])
              if @due_date.present? and @assignment.due_date != @due_date
                @assignment.update(due_date: @due_date)
              end
            end
          end
          if params[:custom_component_graceperiod]
            @graceperiod = params[:custom_component_graceperiod].to_i
            if @graceperiod.present? and @assignment.graceperiod != @graceperiod
              @assignment.update(graceperiod: @graceperiod)
            end
          end
          if params[:custom_component_display_name].present?    
            @display_name = params[:custom_component_display_name]
            if @display_name.present? and @assignment.display_name != @display_name
              @assignment.update(display_name: @display_name)
            end
          end
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
        if @submission.lti_params.blank? and params
          @submission.update :lti_params => params
        end
        render "submissions/show"
      elsif session[:role_type] == "grader"
        @grader ||= Grader.find session[:role_id]
        @context = "You are viewing submissions for the assignment: #{@assignment.description}"
        @submissions = @grader.submissions.from_assignment(@assignment)
        render "submissions/index"
      elsif session[:role_type] == "administrator"
        @context = "You are viewing submissions for the assignment: #{@assignment.description}"
        @submissions = @assignment.submissions
        render "submissions/index"
      else
        check_for_session
      end
    end
  end      
end
