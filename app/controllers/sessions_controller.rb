class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end

  def create
  #  render :new
    user = User.authenticate( params[:session][:email],
                              params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign in"
      render :new
#       redirect_to new_session_path
    else
      sign_in user
      return_to_or(user)
    end

  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
