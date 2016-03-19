class GradersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    @grader = Grader.find params[:id]
  end

  def to_student
    @grader = Grader.find params[:id]
    @student = Student.find_or_create_by :user => @grader.user, :course => @grader.course
    if @student.present?
      @grader.update_attribute(:course_id, nil)      
      @grader.students.each do |student|
        student.update_attribute(:grade_id, nil)
      end
    end    
    redirect_to student_path(@student)
  end  
end
