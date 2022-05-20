json.extract! @user, :username, :id, :set_count
json.online @is_online
json.authenticated @is_authenticated
json.friend !!@has_friendship if @is_authenticated
json.self @is_self if @is_authenticated
json.links @public_links do |link|
  json.partial! 'link', link: link
end