class Admin::UsersController < ApplicationController
  before_action :set_admin
  before_action :set_user, only: [:show, :edit, :update, :destroy]


  def index
    @users = User.all.includes(:tasks).all.order(created_at: :desc)
  end

  def new
    @user = User.new
  end

  def create
  @user = User.new(user_params)
  if @user.save
    redirect_to admin_users_path, notice: "#{@user.name}を追加しました。"
  else
    render :new
  end
end

  def show
    @tasks = @user.tasks
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path(@user), notice:"ユーザー「#{@user.name}」を編集しました"
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path, notice:"ユーザー「#{@user.name}」を削除しました"
    else
      redirect_to admin_users_path, notice:"ユーザー「#{@user.name}」を削除できません"
    end
  end

  private

  def set_admin
    user = current_user
    if user.nil?
      redirect_to tasks_path, notice: 'あなたは管理者ではありません'
    else
      if user.admin == false
        redirect_to new_session_path, notice: 'あなたは管理者ではありません'
      end
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation, :admin)
  end

end
