require "test_helper"

class LeaderboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get leaderboard_index_url
    assert_response :success
  end
end
