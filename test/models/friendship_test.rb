require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase
  test "can't be friends with self" do
    user_id = 69

    friendship = Friendship.new
    friendship.receiver_id = user_id
    friendship.sender_id = user_id
    assert_not friendship.save, 'Saved a friendship where the receiver and sender are the same'
  end
  test "can't be friends with no one" do
    user_id = 69

    friendship = Friendship.new
    friendship.sender_id = user_id
    assert_not friendship.save, 'Saved a friendship where the sender is nil'
  end
end
