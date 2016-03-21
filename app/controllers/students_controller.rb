class StudentsController < ApplicationController
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
    @context = "You are viewing students who %s."

    case params[:status]
    when "has_grader"
      @students = @course.students.has_grader
      @context = @context % "have been assigned to a grader"
    when "no_grader"
      @students = @course.students.no_grader
      @context = @context % "have not been assigned to a grader"
    when "with_ungraded_assignments"
      @students = @course.students.with_ungraded_assignments
      @context = @context % "have not assignments that need to be graded"
    else
      @students = @course.students
      @context = "You are viewing all students in the course."
    end  
    render "index"
  end

  def show
    @student = Student.find params[:id]
  end

  def to_grader
    @student = Student.find params[:id]
    @grader = Grader.find_or_create_by :user => @student.user
    if @grader.present?
      @grader.update_attribute(:course_id, @student.course.id)            
      @student.update_attribute(:course_id, nil)
      # @student.submissions.each do |submission|
      #   submission.update_attribute(:assignment_id, nil)
      # end
    end
    flash[:success] = "Student has been changed to grader."
    redirect_to grader_path(@grader)
  end

  def assign_grader
    @student = Student.find params[:id]
    @grader = Grader.find params[:grader_id]
    @student.update(:grader => @grader)
    flash[:success] = "Student has been assigned to grader."    
    redirect_to student_path(@student)
  end

  def unassign_grader
    @student = Student.find params[:id]
    @student.update(:grader_id => nil)
    flash[:success] = "The grader has been unassigned."    
    redirect_to student_path(@student)
  end
end
