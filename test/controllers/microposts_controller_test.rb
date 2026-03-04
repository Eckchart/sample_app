require "test_helper"

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @micropost = microposts(:orange)
  end

  test "should redirect `create` when not logged in" do
    assert_no_difference 'Micropost.count' do
      post(microposts_path, params: {
        micropost: {
          content: "Lorem ipsum"
        }
      })
    end
    # I guess we here we don't need to check that
    # the http response returned is :see_other, since
    # we don't really care about the response in the
    # case of `create`.
    assert_redirected_to login_url
  end

  test "should redirect `destroy` when not logged in" do
    assert_no_difference "Micropost.count" do
      delete(micropost_path(@micropost))
    end
    assert_response :see_other
    assert_redirected_to login_url
  end
end
