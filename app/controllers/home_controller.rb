class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    if session[:course_id].present?
      @course = Course.find session[:course_id]
    else
      check_for_session
    end

    if session[:role_type] == "student"
      redirect_to student_path(session[:role_id])
    elsif session[:role_type] == "grader"
      redirect_to grader_path(session[:role_id])
    end
  end
end
