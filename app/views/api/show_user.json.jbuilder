json.extract! @user, :username, :id, :set_count
json.online @is_online
json.friend !!@has_friendship
json.self @is_self
json.links @public_links do |link|
  json.partial! 'link', link: link
end