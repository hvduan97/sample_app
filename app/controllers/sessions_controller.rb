class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      if user.activated?
        login user
      else
        message = t "controllers.sessions_controller.message"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = t "controllers.sessions_controller.message_error"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def login user
    log_in user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
    redirect_back_or user
  end
end
