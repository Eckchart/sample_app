require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch(user_path(@user), params: {
      user: {
        name: "",
        email: "foo@invalid",
        password: "foo",
        password_confirmation: "bar"
      }
    })
    assert_template 'users/edit'

    # Make this assert a bit more future-proof.
    assert_select 'div.alert', /4.*errors/i
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    assert_includes session[:forwarding_url], edit_user_path(@user)

    log_in_as(@user)
    assert_nil session[:forwarding_url]  # session cleared just before logging in
    assert_redirected_to edit_user_url(@user)

    log_in_as(@user)  # log in a second time

    # No forwarding URL this time, since we haven't
    # navigated to any (protected) page before trying
    # to log in.
    assert_nil session[:forwarding_url]
    assert_redirected_to @user  # should redirect to the default URL this time

    name = "Foo Bar"
    email = "foo@bar.com"
    patch(user_path(@user), params: {
      user: {
        name: name,
        email: email,
        password: "",
        password_confirmation: ""
      }
    })
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
