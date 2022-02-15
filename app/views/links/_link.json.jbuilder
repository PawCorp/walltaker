json.extract! link, :id, :expires, :user_id, :terms, :blacklist, :post_url, :post_thumbnail_url, :post_description, :created_at, :updated_at
json.set_by @set_by.nil? ? nil : @set_by.username # DO NOT EXPOSE WHOLE OBJECT! TODO: I'm lazy and need to add guards to prevent leaking user emails.
json.url link_url(link, format: :json)