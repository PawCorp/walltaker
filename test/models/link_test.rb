require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  test 'expiry date required when not never_expires' do
    link = Link.new
    link.never_expires = false
    link.expires = nil

    assert_not link.save, 'saved an expiring link with a nil expiry date'
  end
  test 'theme should not have spaces' do
    link = Link.new
    link.never_expires = true
    link.theme = 'this is a multi tag theme'

    assert_not link.save, 'saved a theme with multiple tags'
  end
end
