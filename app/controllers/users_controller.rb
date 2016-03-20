class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_provider_info

  def new
    if @user.present?
      flash.now[:success] = "It looks like a user has already been created. You should be good to go dude."
    else
      @user = User.find_by_email @provider.lis_person_contact_email_primary
      if @user.present?
        flash.now[:success] = "It looks like a user has already been created. You should be good to go dude."
      elsif @provider.user_id.present? and @provider.lis_person_contact_email_primary.present? and @provider.lis_person_sourcedid.present?
        @password = (0...8).map { (65 + rand(26)).chr }.join
        @user = User.new :identifier => @provider.user_id, :email => @provider.lis_person_contact_email_primary, :username => @provider.lis_person_sourcedid, :password => @password, :password_confirmation => @password 
        if @user.save
          flash.now[:success] = "We were able to create an account for you."
        else
          flash.now[:danger] = @user.errors.full_messages[0]
        end
      else
        flash.now[:danger] = "For some reason the email and/or username wasn't submitted."
      end
    end

    redirect_to root_path
  end
end
