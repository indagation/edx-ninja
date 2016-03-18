class StudentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    @student = Student.find params[:id]

    if session[:role_type] == "student"
      render "show"
    elsif session[:role_type] == "grader"
      render "show_grader"
    elsif session[:role_type] == "administrator"
      render "show_admin"
    end
  end

  def to_grader
    @student = Student.find params[:id]
    @grader = Grader.find_or_create_by :user => @student.user, :course => @student.course
    if @grader.present?
      @student.update_attribute(:course_id, nil)
    end
    redirect_to grader_path(@grader)
  end
end
