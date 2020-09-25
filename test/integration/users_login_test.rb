require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  # [TODO] fix login_path 
  test "login with invalid information" do
    get login_path
    post login_path, params: { session: { name: "", password: "" } }
  end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { name:    @user.name,
                                          password: 'password' } }
    delete logout_path
  end
end
