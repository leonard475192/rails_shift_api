class SessionsController < ApplicationController

  def create
    user = User.find_by(name: params[:session][:name])
    if user && user.authenticate(params[:session][:password])
      render plain: login_user.token
    else
      render plain: 'no auth'
    end
  end
end
