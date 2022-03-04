require "test_helper"

class PornSearchControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get porn_search_index_url
    assert_response :success
  end

  test "should get list" do
    get porn_search_list_url
    assert_response :success
  end
end
