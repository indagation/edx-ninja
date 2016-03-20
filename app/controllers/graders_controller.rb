class GradersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def admin
    if session[:course_id].present?
      @course = Course.find session[:course_id]
    else
      check_for_session
    end
  end

  def course
    @course = Course.find params[:course_id]
    @context = "You are viewing graders who %s."

    case params[:status]
    when "with_students"
      @graders = @course.graders.with_students
      @context = @context % "have students assigned to them"
    when "without_students"
      @graders = @course.graders.without_students
      @context = @context % "have no students assigned to them"
    when "with_ungraded_assignments"
      @graders = @course.graders.with_ungraded_assignments
      @context = @context % "have assignments left to grade"
    when "without_ungraded_assignments"
      @graders = @course.graders.without_ungraded_assignments
      @context = @context % "have graded all of their assignments" 
    else
      @graders = @course.graders
      @context = "You are viewing all students in the course."
    end
    render "index"
  end

  def show
    @grader = Grader.find params[:id]
  end

  def update
    @grader = Grader.find params[:id]
    if @grader.update(grader_params)
      flash.now[:success] = "Grader Updated"
    else
      flash.now[:danger] = @grader.errors.full_messages[0]
    end
    render "show"
  end    

  def to_student
    @grader = Grader.find params[:id]
    @student = Student.find_or_create_by :user => @grader.user
    if @student.present?
      @student.update_attribute(:course_id, @grader.course.id)      
      @grader.update_attribute(:course_id, nil)      
      @grader.students.each do |student|
        student.update_attribute(:grader_id, nil)
      end
    end
    flash[:success] = "Grader has been changed to student."
    redirect_to student_path(@student)
  end

  private
  def grader_params
    params.require(:grader).permit(:max_students)
  end    
end
