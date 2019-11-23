class UsersController < ApplicationController

  power crud: :users, as: :user_scope

  rescue_from Consul::Powerless do
    if Setting.get_or_initialize.lock_sign_up
      flash[:danger] = 'Sign up is locked'
      redirect_to games_path
    end
  end

  def new
    build_user
    render 'new', layout: 'signin_layout'
  end

  def create
    build_user
    @user.sign_up_ip = request.ip
    if save_user
      flash[:success] = "Successfully signed up, you can sign in now"
      redirect_to signin_path
    else
      render 'new', layout: 'signin_layout'
    end
  end

  def index
    load_users
  end

  def edit
    load_user
    build_user
  end

  def update
    load_user
    build_user
    if save_user
      flash[:success] = 'User saved'
      redirect_to users_path
    else
      render 'edit'
    end
  end

  def destroy
    load_user
    @user.destroy
    flash[:success] = 'User deleted'
    redirect_to users_path
  end

  private

  def load_user
    @user ||= user_scope.find(params[:id])
  end

  def load_users
    @users ||= user_scope.order(:name).to_a
  end

  def build_user
    @user ||= user_scope.build
    @user.attributes = user_params
  end

  def save_user
    @user.save
  end

  def user_params
    user_params = params[:user]
    user_params ? user_params.permit(*current_power.permittable_user_params) : {}
  end

end
