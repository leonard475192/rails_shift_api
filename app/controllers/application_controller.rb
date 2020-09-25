class ApplicationController < ActionController::API
  # APIモードでは使えないらしい
  # protect_from_forgery with: :exception
  include SessionsHelper
end
