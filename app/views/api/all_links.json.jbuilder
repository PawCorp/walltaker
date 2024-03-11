json.cache! ['v1', 'all_links api', @force_online], expires_in: 5.minutes do
  json.array! @links do |link|
    json.partial! 'link', link: link
  end
end