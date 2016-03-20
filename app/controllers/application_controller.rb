class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def set_provider_info
    consumer_key = "client-key"
    consumer_secret = "client-secret"

    @provider = IMS::LTI::ToolProvider.new(consumer_key, consumer_secret, params)
    unless @provider.valid_request?(request)
      error
    end

    if @provider.user_id.present?
      @user = User.find_by_id @provider.user_id
    end

    reset_session
    if @provider.context_id.present?
      @course = Course.find_or_create_by :context_id => @provider.context_id
      session[:course_id] = @course.id
    end

    if @provider.roles.include? "administrator" or @provider.roles.include? "instructor"
      @administrator = Administrator.find_or_create_by :user => @user, :course => @course
      session[:role_type] = "administrator"
      session[:role_id] = @administrator.id
    elsif @provider.roles.include? "staff"
      @staff = Staff.find_or_create_by :user => @user, :course => @course
      session[:role_type] = "staff"
      session[:role_id] = @staff.id      
    elsif @provider.roles.include? "instructor"  
      session[:role_type] = "instructor"    
    elsif(@user.present? and @grader = Grader.find_by(:user => @user, :course => @course))
      session[:role_type] = "grader"
      session[:role_id] = @grader.id
    elsif @user.present?
      @student = Student.find_or_create_by :user => @user, :course => @course
      session[:role_type] = "student"
      session[:role_id] = @student.id
    end
  end

  before_action :remove_x_frame_restriction
  def remove_x_frame_restriction
    response.headers.except! 'X-Frame-Options'
  end
end
