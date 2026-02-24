require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    # From fixture '/test/fixtures/users.yml'.
    @user = users(:michael)
  end
  
  test "login with valid email / invalid password" do
    get login_path
    assert_template 'sessions/new'
    post(login_path, params: {
      session: {
        email: "michael@example.com",
        password: "invalid"
      }
    })
    assert_response :unprocessable_entity
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information" do
    # ASSUME ALL FIXTURE USERS HAVE THE SAME
    # PASSWORD (i.e. 'password').
    post(login_path, params: {
      session: {
        email: @user.email,
        password: 'password'
      }
    })
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end
end
