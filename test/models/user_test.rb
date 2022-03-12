require "test_helper"

class UserTest < ActiveSupport::TestCase
  test 'no punctuation in usernames' do
    user = User.new
    user.username = '!what ?'
    assert_not user.valid?
  end
end
