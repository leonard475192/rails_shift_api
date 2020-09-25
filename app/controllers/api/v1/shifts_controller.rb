class Api::V1::ShiftsController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate
  before_action :set_shift, only: [:update, :destroy]
  before_action :admin_user,     only: [:update]

  # 決定しているシフト
  def index
    shifts = Shift.where(draft: true).order(workday: :desc)
    render json: { status: 'SUCCESS', message: 'Loaded shifts', shift: shifts }
  end

  # 自分 or 管理者
  # 自分のシフト
  def show
    shifts = Shift.where(user_id: params[:id])
    render json: { status: 'SUCCESS', message: 'Loaded the shift', shift: shifts }
  end

  # 自分 or 管理者
  def create
    shift = Shift.new(shift_params)
    if (shift.user_id == @auth_user.id) || @auth_user.admin?
      if shift.save
        render json: { status: 'SUCCESS', shift: shift }
      else
        render json: { status: 'ERROR', shift: shift.errors }
      end
    else
      render json: { status: 'ERROR', message: 'Not a proper user.' } 
    end
  end

  # 管理者
  def update
    if @shift.update(shift_params)
      render json: { status: 'SUCCESS', message: 'Updated the shift', shift: @shift }
    else
      render json: { status: 'ERROR', message: 'Not updated', shift: @shift.errors }
    end
  end

  # draft:false 自分
  # draft:true 管理者
  def destroy
    if (!@shift.draft? && @shift.user_id == @admin_user.id) || @auth_user.admin?
      @shift.destroy
      render json: { status: 'SUCCESS', message: 'Deleted the shift', shift: @shift }
    else
      render json: { status: 'ERROR', message: 'Not a proper user.' }
    end
  end

  private

    def set_shift
      @shift = Shift.find(params[:id])
    end

    def shift_params
      params.require(:shift).permit(:user_id, :date)
    end

    def admin_user
      render json: { status: 'ERROR', message: 'Not a proper user.' } unless @auth_user.admin?
    end

    def authenticate
      authenticate_or_request_with_http_token do |token,options|
        @auth_user = User.find_by(token: token)
        @auth_user != nil ? true : false
      end
    end
end

