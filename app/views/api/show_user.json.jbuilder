json.extract! @user, :username, :id
json.online @is_online
json.friend !!@has_friendship
json.self @is_self
json.links @user.link do |link|
  json.partial! 'link', link: link
end