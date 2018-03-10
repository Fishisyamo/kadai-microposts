class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show,
                                                :followings, :followers]

  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order('created_at DESC').page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end

  def followings
    @user = User.find(params[:id])
    @users = @user.followings.page(params[:page])
    counts(@user)
    render 'show_follow'
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers.page(params[:page])
    counts(@user)
    render 'show_follow'
  end

  private

    def user_params
      params.require(:user).permit(:name, :email,
                                   :password, :password_confirmation)
    end
end