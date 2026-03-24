require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
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

  test "valid signup information" do
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
    follow_redirect!
    # assert_template 'users/show'
    assert_not flash.empty?
    # assert is_logged_in?
  end
end
