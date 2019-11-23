class SessionsController < ApplicationController

  def new
    if signed_in?
      redirect_to root_url
    else
      build_sign_in
      render 'new', layout: 'signin_layout'
    end
  end

  def create
    build_sign_in
    user = save_sign_in
    if user
      if user.locked?
        flash.now[:danger] = 'Your account is locked'
        render 'new', layout: 'signin_layout'
      else
        user.update!(last_sign_in_at: Time.now, last_sign_in_ip: request.ip)
        sign_in user
        flash[:success] = "Successfully signed in."
        redirect_back_or root_url
      end
    else
      render 'new', layout: 'signin_layout'
    end
  end


  def destroy
    sign_out if signed_in?
    flash[:success] = 'Successfully signed out.'
    redirect_to signin_url
  end

  private

  def build_sign_in
    @sign_in ||= User::SignIn.new
    @sign_in.attributes = sign_in_params
  end

  def save_sign_in
    @sign_in.save
  end


  def sign_in_params
    sign_in_params = params[:user_sign_in]
    sign_in_params ? sign_in_params.permit(:username, :password) : {}
  end

end
