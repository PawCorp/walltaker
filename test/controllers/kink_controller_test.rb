require "test_helper"

class KinkControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get kink_show_url
    assert_response :success
  end

  test "should get add" do
    get kink_add_url
    assert_response :success
  end

  test "should get remove" do
    get kink_remove_url
    assert_response :success
  end
end
