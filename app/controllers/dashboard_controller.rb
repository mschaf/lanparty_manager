class DashboardController < ApplicationController

  def index
    unless signed_in?
      redirect_to sign_in_url
    end
  end


end