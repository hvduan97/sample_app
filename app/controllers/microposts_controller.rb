class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    build_micropost
    if @micropost.save
      flash[:success] = t "controllers.microposts_controller.create"
      redirect_to root_path
    else
      @feed_items = current_user.feed.page(params[:page])
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "controllers.microposts_controller.delete"
    else
      flash[:danger] = t "controllers.microposts_controller.delete_fail"
    end
    redirect_to request.referer || root_path
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :image
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_path unless @micropost
  end

  def build_micropost
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach micropost_params[:image]
  end
end
