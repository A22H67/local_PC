class UsersController < ApplicationController
  before_action :logged_in_user,only: [:index,:edit,:update,:destroy]
  before_action :correct_user,   only: [:edit,:update]
  before_action :admin_user,     only: :destroy
  def index
    @user = User.all
  end
  def new
    @user = User.new
  end
  def show
    @user = User.find(params[:id])
    #debugger
  end
  def create
    @user = User.new(user_params)
    if @user.save
      #Handle
      log_in(@user)
      flash[:success] = "Welcome #{@user.name}"
      redirect_to @user
    else
      render :new,status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      #handle
    else
      render :edit,status: :unprocessable_entity
    end
  end
  def destroy
    @user = User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_path
  end

  private
  def user_params
    params.require(:user).permit(:name,:email,:password)
  end
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find(params[:id])
    #flash[:danger] = "You're not authorized for this action"
    redirect_to root_url if @user != current_user
  end
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
