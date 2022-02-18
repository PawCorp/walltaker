module ApplicationHelper
  def has_requests?
    return Friendship.all.where(receiver_id: current_user.id, confirmed: false).count.positive? if current_user

    false
  end
end
