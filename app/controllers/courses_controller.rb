class CoursesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def students_search
    @course = Course.find(params[:id])
    @students = @course.students.joins(:user).where("users.username LIKE ?", "%#{params[:username]}%")
  end

  def graders_search
    @course = Course.find(params[:id])
    @graders = @course.graders.joins(:user).where("users.username LIKE ?", "%#{params[:username]}%")    
  end    
end
