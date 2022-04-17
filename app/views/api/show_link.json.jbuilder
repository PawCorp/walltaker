json.partial! 'link', link: @link
json.set_by @set_by.nil? ? nil : @set_by.username # DO NOT EXPOSE WHOLE OBJECT! TODO: I'm lazy and need to add guards to prevent leaking user emails.
json.url link_url(@link, format: :json)