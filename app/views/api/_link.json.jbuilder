json.extract! link, :id, :expires, :terms, :blacklist, :post_url, :post_thumbnail_url, :post_description, :created_at, :updated_at, :response_type, :response_text
json.username link.user.username
json.set_by set_by.username if (defined? set_by) && set_by.present? # DO NOT EXPOSE WHOLE OBJECT! TODO: I'm lazy and need to add guards to prevent leaking user emails.
json.online link.updated_at > Time.now - 1.minute