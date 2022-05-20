json.extract! @user, :username, :id
json.online @is_online
json.friend !!@has_friendship
json.self @is_self
json.links @public_links do |link|
  json.partial! 'link', link: link
end