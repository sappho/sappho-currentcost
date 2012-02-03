class AdministratorController < ApplicationController
  def login
    session[:loggedIn] = true if Digest::SHA1.hexdigest(params[:password]) == SapphoCurrentCost::Application.config.admin_password_hash
    redirect_to request.referer
  end
  def logout
    session[:loggedIn] = false
    redirect_to request.referer
  end
end
