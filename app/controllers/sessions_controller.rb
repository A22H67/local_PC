class SessionsController < ApplicationController
  def new
  end
  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in(user) # create session token
      #remember(user) #remember user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user
    else
      flash.now[:danger] = "Invalid email/password combination"
      render :new,status: :unprocessable_entity
    end

  end
  def destroy
    log_out
    redirect_to root_url
  end
end
