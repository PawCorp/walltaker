require "test_helper"

class SurrendersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get surrenders_index_url
    assert_response :success
  end

  test "should get show" do
    get surrenders_show_url
    assert_response :success
  end
  test "should get create" do
    get surrenders_create_url
    assert_response :success
  end

  test "should get new" do
    get surrenders_new_url
    assert_response :success
  end

  test "should get destroy" do
    get surrenders_destroy_url
    assert_response :success
  end

  test "should get show" do
    get surrenders_show_url
    assert_response :success
  end
end
