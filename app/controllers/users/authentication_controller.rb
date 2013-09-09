class Users::AuthenticationController < ApplicationController
  def index
      @authentications = Authentication.all
  end

  def create
    auth =  request.env["omniauth.auth"]
    current_user.authentications.create(:provider => auth['provider'], :uid => auth['uid'])
    flash[:notice] = "Authentication sucessfull"
    redirect_to authentications_url
  end

  def destroy
  end
end
