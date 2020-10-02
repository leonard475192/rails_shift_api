class Api::V1::SessionsController < ApplicationController

  def create
    user = User.find_by(name: params[:name])
    if user && user.authenticate(params[:password])
      if user.activated?
        render json: { status: 'SUCCESS', data: user.token }
      else
        render json: { status: 'ERROR', data: 'Please wait for permission' }
      end
    else
      render json: { status: 'ERROR', data: 'no auth' }
    end
  end
end
