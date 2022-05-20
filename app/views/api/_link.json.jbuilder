json.extract! link, :id, :expires, :terms, :blacklist, :post_url, :post_thumbnail_url, :post_description, :created_at, :updated_at, :response_type, :response_text
json.username link.user.username
json.online link.updated_at > Time.now - 1.minute