require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end
 
  test "login with invalid information" do
    post '/api/v1/login', params: { name: "", password: "" } 
  end

  test "login with valid information" do
    post '/api/v1/login', params: { name:    @user.name,
                                    password: 'password' } 
  end
end
