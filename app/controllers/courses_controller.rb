class CoursesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def students_search
    @course = Course.find(params[:id])
    @students = @course.students.joins(:user).where("users.username LIKE ?", "%#{params[:username]}%")
    if @students.present?
      flash.now[:success] = "We found #{pluralize(@students.count, 'student')} matching your search results."
    else
      flash.now[:danger] = "No search results were returned."
    end      
  end

  def graders_search
    @course = Course.find(params[:id])
    @graders = @course.graders.joins(:user).where("users.username LIKE ?", "%#{params[:username]}%")  
    if @graders.present?
      flash.now[:success] = "We found #{pluralize(@graders.count, 'grader')} matching your search results."
    else
      flash.now[:danger] = "No search results were returned."
    end
  end    
end
