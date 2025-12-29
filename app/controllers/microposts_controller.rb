class MicropostsController < ApplicationController
  before_action :logged_in_user , only: [:create, :destroy]
  before_action :correct_user, only: [:destroy]
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts
  end
  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @feed_items = current_user.feed
      render 'static_pages/home', status: :unprocessable_entity
    end

  end
  def destroy
  @micropost.destroy
  flash[:success] = "Micropost delete!"
  redirect_to request.referrer || root_path
  end

  private
  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end
  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end
