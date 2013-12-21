require 'test_helper'

class SigninControllerTest < ActionController::TestCase
  test "should get sighin_page" do
    get :sighin_page
    assert_response :success
  end

end
