require "test_helper"

class UserShowTest < ActionDispatch::IntegrationTest
  def setup
    @unactivated_user = users(:unactivated)
    @activated_user = users(:archer)
  end

  test "should redirect when user is not activated" do
    get user_path(@unactivated_user)
    assert_response :found  # Idk if this is the response the exercise wanted..
    assert_redirected_to root_url
  end

  test "should display user when activated" do
    get user_path(@activated_user)
    assert_response :ok  # Idk if this is the response the exercise wanted..
    assert_template 'users/show'
  end
end
