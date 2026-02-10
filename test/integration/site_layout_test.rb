require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout links" do
    get root_path

    # Verify that the Home page is rendered using the correct view.
    assert_template 'static_pages/home'

    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path

    # Is it good to do this test here if we already do it in
    # the tests for static pages controller??
    get contact_path
    assert_select "title", full_title("Contact") 
  end
end
