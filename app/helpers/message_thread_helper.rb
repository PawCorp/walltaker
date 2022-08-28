module MessageThreadHelper
  def convert_all_e621_links_to_source_links(string)
    matches = string.scan(/(https:\/\/e621\.net\/posts\/)(\d*)(\?[\w\=\&\%\+]*)?/)

    output = string
    matches.each do |match|
      root = match[0]
      post_id = match[1]
      meta = match[2] if match[2].present?
      meta = '' unless match[2].present?
      original_substring = root + post_id + meta

      cached_url = CachedPost.where(post_id: post_id).limit 1

      if cached_url&.first
        output = output.gsub(original_substring, cached_url.first&.url)
      else
        response = Excon.get(
          "https://e621.net/posts/#{post_id.to_i}.json",
          headers: { 'User-Agent': 'walltaker.joi.how (by ailurus on e621)' }
        )
        if response.status != 200
          track :error, :e621_post_api_fail_in_Message_Thread_previewer, response: response, post_id: post_id.to_i
          return nil
        end

        begin
          post_response = JSON.parse(response.body)
          url = post_response['post']['file']['url']
          output = output.gsub(original_substring, url)
          CachedPost.create post_id: post_id, url: url
        rescue
          track :error, :e621_post_unreadable_fail_in_Message_Thread_previewer, response: response, post_id: post_id.to_i
          return nil
        end
      end
    end

    return output
  end
end
