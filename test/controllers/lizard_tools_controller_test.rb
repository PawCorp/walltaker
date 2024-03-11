require "test_helper"

class LizardToolsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get lizard_tools_index_url
    assert_response :success
  end

  test "should get warren" do
    get lizard_tools_warren_url
    assert_response :success
  end

  test "should get ki" do
    get lizard_tools_ki_url
    assert_response :success
  end

  test "should get talyor" do
    get lizard_tools_talyor_url
    assert_response :success
  end
end
