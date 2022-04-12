require "test_helper"

class NotificationControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get notification_show_url
    assert_response :success
  end
end
