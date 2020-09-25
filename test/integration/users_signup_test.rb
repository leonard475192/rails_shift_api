require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    assert_no_difference 'User.count' do
      post '/api/v1/users', params:{ user: { name:  "",
                                      password:              "foo",
                                      password_confirmation: "bar" }}
    end
  end

  test "valid signup information" do
    assert_difference 'User.count', 1 do
      post '/api/v1/users', params:{ user: { name:  "Example User",
                                      password:              "password",
                                      password_confirmation: "password" }}
    end
  end
end