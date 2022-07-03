class PornSearchController < ApplicationController
  def index

  end

  def search
    @page_number = porn_search_params[:page_number].to_i
    @page_number = 1 if @page_number == 0
    @link = Link.find(porn_search_params[:link]) if porn_search_params[:link]
    sanitized_blacklist = @link.blacklist.downcase.gsub(/[^a-z_\(\)\d ]/, '')
    append_to_tags = ''
    append_to_tags += @link.theme if (@link.theme)
    append_to_tags += ' ' + ((sanitized_blacklist.split.map { |tag| "-#{tag}" }).join ' ') unless (sanitized_blacklist.empty?)
    @posts = get_tag_results porn_search_params[:tags], porn_search_params[:after], porn_search_params[:before], append_to_tags
    @last_tags = porn_search_params[:tags]

    track :regular, :search_e621_on_link, search: porn_search_params[:tags]

    redirect_to :index if @posts.nil?
  end

  private

  def get_tag_results(tag_string, after, before, append_to_tags)
    padded_tag_string = tag_string + ' -animated'
    unless append_to_tags.nil? || append_to_tags.empty?
      padded_tag_string = "#{padded_tag_string} #{append_to_tags.to_s}"
    end
    tags = CGI.escape padded_tag_string
    url = "https://e621.net/posts.json?tags=#{tags}&limit=15"
    after_id = after.gsub(/\D/, '') if after
    url = "#{url}&page=b#{after_id}" if after_id
    before_id = before.gsub(/\D/, '') if before
    url = "#{url}&page=a#{before_id}" if before_id
    response = Excon.get(url, headers: { 'User-Agent': 'walltaker.joi.how (by ailurus on e621)' })
    if response.status != 200
      track :error, :e621_posts_api_fail, response: response
      return nil
    end

    results = JSON.parse(response.body)['posts']

    if results.present? && results.class == Array
      results.filter do |post|
        post['file']['ext'] == 'png' || post['file']['ext'] == 'jpg' if post['file'] && post['file']['ext']
      end
    else
      []
    end
  end

  # Only allow a list of trusted parameters through.
  def porn_search_params
    params.permit(:tags, :after, :before, :page_number, :link)
  end
end
