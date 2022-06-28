require "test_helper"

class OrgasmsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @orgasm = orgasms(:one)
  end

  test "should get index" do
    get orgasms_url
    assert_response :success
  end

  test "should get new" do
    get new_orgasm_url
    assert_response :success
  end

  test "should create orgasm" do
    assert_difference("Orgasm.count") do
      post orgasms_url, params: { orgasm: { is_ruined: @orgasm.is_ruined, rating: @orgasm.rating, user_id: @orgasm.user_id } }
    end

    assert_redirected_to orgasm_url(Orgasm.last)
  end

  test "should show orgasm" do
    get orgasm_url(@orgasm)
    assert_response :success
  end

  test "should get edit" do
    get edit_orgasm_url(@orgasm)
    assert_response :success
  end

  test "should update orgasm" do
    patch orgasm_url(@orgasm), params: { orgasm: { is_ruined: @orgasm.is_ruined, rating: @orgasm.rating, user_id: @orgasm.user_id } }
    assert_redirected_to orgasm_url(@orgasm)
  end

  test "should destroy orgasm" do
    assert_difference("Orgasm.count", -1) do
      delete orgasm_url(@orgasm)
    end

    assert_redirected_to orgasms_url
  end
end
