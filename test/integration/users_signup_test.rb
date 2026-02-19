require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path  # techincally optional
    assert_no_difference "User.count" do
      post(users_path, params: { user: {
        name: "",
        email: "user@invalid",
        password: "foo",
        password_confirmation: "bar"
      }})
    end
    assert_response :unprocessable_entity
    assert_template 'users/new'

    # Check that the div explaining the errors (and displaying
    # the error count (should be 4 for this test)) appeared.
    assert_select 'div#error_explanation'

    # Check that the number of errors for this test is 4 (Rails
    # also wraps the labels with the `field_with_errors` class so
    # we need to check the count to be 4 * 2 = 8)
    assert_select 'div.field_with_errors', count: 4 * 2

    # Idk if we can test more than this.. seems too brittle to
    # check for string in the actual error messages or anything
    # like that.
  end
end
