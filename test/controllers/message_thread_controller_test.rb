require "test_helper"

class MessageThreadControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get message_thread_index_url
    assert_response :success
  end

  test "should get show" do
    get message_thread_show_url
    assert_response :success
  end

  test "should get new" do
    get message_thread_new_url
    assert_response :success
  end

  test "should get create" do
    get message_thread_create_url
    assert_response :success
  end

  test "should get delete" do
    get message_thread_delete_url
    assert_response :success
  end

  test "should get edit" do
    get message_thread_edit_url
    assert_response :success
  end

  test "should get change" do
    get message_thread_change_url
    assert_response :success
  end
end
