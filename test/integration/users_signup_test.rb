require "test_helper"

class UsersSignup < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end
end


class UsersSignupTest < UsersSignup
  test "invalid signup information" do
    get signup_path  # techincally optional
    assert_no_difference "User.count" do
      post(users_path, params: {
        user: {
          name: "",
          email: "user@invalid",
          password: "foo",
          password_confirmation: "bar"
        }
      })
    end
    assert_response :unprocessable_entity
    assert_template 'users/new'

    # Check that the div explaining the errors (and displaying
    # the error count) appeared.
    assert_select 'div#error_explanation'

    assert_select 'div.field_with_errors input#user_name'
    assert_select 'div.field_with_errors input#user_email'
    assert_select 'div.field_with_errors input#user_password'
    assert_select 'div.field_with_errors input#user_password_confirmation'
  end

  test "valid signup information with account activation" do
    get signup_path  # technically optional
    assert_difference "User.count", 1 do
      post(users_path, params: {
        user: {
          name: "Example User",
          email: "user@example.com",
          password: "password",
          password_confirmation: "password"
        }
      })
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
  end
end


# The tutorial says *NOT* to use a `setup` method in a class that
# ends with `Test` and a few pages later does it anyway XDD so I
# re-refactored the `setup` method to be contained in this class only.
class AccountActivation < UsersSignup
  def setup
    super
    post(users_path, params: {
      user: {
        name: "Example User",
        email: "user@example.com",
        password: "password",
        password_confirmation: "password"
      }
    })
    @user = assigns(:user)
  end
end


class AccountActivationTest < AccountActivation
  test "should not be activated" do
    assert_not @user.activated?
  end

  test "should not be able to log in before account activation" do
    log_in_as(@user)
    assert_not is_logged_in?
  end

  test "should not be able to log in with invalid activation token" do
    get edit_account_activation_path("invalid token", email: @user.email)
    assert_not is_logged_in?
  end

  test "should not be able to log in with invalid email" do
    get edit_account_activation_path(@user.activation_token, email: "wrong")
    assert_not is_logged_in?
  end

  test "should log in successfully with valid activation token and email" do
    get edit_account_activation_path(@user.activation_token, email: @user.email)
    assert @user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in?
  end
end
