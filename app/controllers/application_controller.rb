class ApplicationController < ActionController::Base

  include SessionsHelper
  include Consul::Controller

  current_power do
    Power.new(current_user)
  end

  def ensure_login
    unless signed_in?
      store_location
      flash[:danger] = "Please sign in."
      redirect_to signin_url
    end
  end

end
