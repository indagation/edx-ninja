class StudentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    @student = Student.find params[:id]
    show_template
  end

  def to_grader
    @student = Student.find params[:id]
    @grader = Grader.find_or_create_by :user => @student.user, :course => @student.course
    if @grader.present?
      @student.update_attribute(:course_id, nil)
    end
    redirect_to grader_path(@grader)
  end

  def assign_grader
    @student = Student.find params[:id]
    @grader = Grader.find params[:grader_id]
    @student.update(:grader => @grader)
    show_template
  end

  def unassign_grader
    @student = Student.find params[:id]
    @student.update(:grader_id => nil)
    show_template
  end

  private
  def show_template
    if session[:role_type] == "student"
      render "show"
    elsif session[:role_type] == "grader"
      render "show_grader"
    elsif session[:role_type] == "administrator"
      render "show_admin"
    end
  end
end
