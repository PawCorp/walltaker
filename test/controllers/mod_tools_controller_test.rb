require "test_helper"

class ModToolsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get mod_tools_index_url
    assert_response :success
  end

  test "should get show_password_reset" do
    get mod_tools_show_password_reset_url
    assert_response :success
  end

  test "should get update_password_reset" do
    get mod_tools_update_password_reset_url
    assert_response :success
  end

  test "should get show_user" do
    get mod_tools_show_user_url
    assert_response :success
  end

  test "should get destroy_user" do
    get mod_tools_destroy_user_url
    assert_response :success
  end
end
