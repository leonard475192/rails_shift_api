class Api::V1::UsersController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate, only: [:index, :show, :update, :destroy]
  before_action :set_user, only: [:show, :update, :update_all, :destroy]
  before_action :admin_user,     only: [:index, :update_all, :destroy]

  # 管理者のみ
  def index
    users = User.order(created_at: :desc)
    render json: { status: 'SUCCESS', message: 'Loaded users', user: users }
  end

  # 準備中
  def show
    render json: { status: 'SUCCESS', message: 'In preparation'}
  end

  # 唯一認証必要なし
  # 成功したら、アクセス許可がないことを返す
  def create
    user = User.new(user_params)
    if user.save
      render json: { status: 'SUCCESS', data: user.activated }
    else
      render json: { status: 'ERROR', data: user.errors }
    end
  end

  # 自分だけ
  def update
    if @auth_user.id == @user.id  
      if @user.update(user_params)
        render json: { status: 'SUCCESS', message: 'Updated the user', user: @user }
      else
        render json: { status: 'ERROR', message: 'Not updated', user: @user.errors }
      end
    else 
      render json: { status: 'ERROR', message: 'Not a proper user.' }
    end
  end

  # 管理者のみ
  def update_all
    if @user.update(admin_params)
        render json: { status: 'SUCCESS', message: 'Updated the user', user: @user }
      else
        render json: { status: 'ERROR', message: 'Not updated', user: @user.errors }
    end
  end

  # 管理者のみ
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    render json: { status: 'SUCCESS', message: 'Deleted the user', user: @user }
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.permit(:name, :password, :password_confirmation)
    end

    def admin_params
      params.permit(:name, :activated, :admin)
    end

    def admin_user
      render json: { status: 'ERROR', message: 'Not a proper user.' } unless @auth_user.admin?
    end

    # 認証
    def authenticate
      authenticate_or_request_with_http_token do |token,options|
        @auth_user = User.find_by(token: token)
        @auth_user != nil ? true : false
      end
    end
end

