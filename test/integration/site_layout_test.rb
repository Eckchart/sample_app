require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
  
  test "layout links" do
    get root_path

    # Verify that the Home page is rendered using the correct view.
    assert_template 'static_pages/home'

    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", users_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
    assert_select "a[href=?]", edit_user_path(@user), count: 0
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", signup_path

    # Is it good to do this test here if we already do it in
    # the tests for static pages controller??
    get contact_path
    assert_select "title", full_title("Contact") 

    get signup_path
    assert_select "title", full_title("Sign up")

    # Test behavior for non-logged-in users (idk we
    # shouldn't really have to do this here).
    get users_path
    assert_redirected_to login_url

    log_in_as(@user)
    follow_redirect!
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", login_path, count: 0

    # Don't need to do this technically since, due to
    # friendly forwarding, we would already be redirected
    # to the `users_path` after logging in, but I wanted
    # to be explicit.
    get users_path
    assert_select 'ul.users'
  end
end
