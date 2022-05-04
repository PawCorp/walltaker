class PornSearchController < ApplicationController
  def index

  end

  def search
    @link = Link.find(porn_search_params[:link]) if porn_search_params[:link]
    sanitized_blacklist = @link.blacklist.downcase.gsub(/[^a-z_\(\)\d ]/, '')
    append_to_tags = ''
    append_to_tags += @link.theme if (@link.theme)
    append_to_tags += ' ' + ((sanitized_blacklist.split.map { |tag| "-#{tag}"}).join ' ') unless (sanitized_blacklist.empty?)
    @posts = get_tag_results porn_search_params[:tags], porn_search_params[:after], append_to_tags
    @last_tags = porn_search_params[:tags]

    track :regular, :search_e621_on_link, search: porn_search_params[:tags]

    redirect_to :index if @posts.nil?
  end

  private

  def get_tag_results(tag_string, after, append_to_tags)
    padded_tag_string = tag_string + ' type:jpg type:png'
    unless append_to_tags.nil? || append_to_tags.empty?
      padded_tag_string = "#{padded_tag_string} #{append_to_tags.to_s}"
    end
    tags = CGI.escape padded_tag_string
    url = "https://e621.net/posts.json?tags=#{tags}&limit=15"
    after_id = after.gsub(/\D/, '') if after
    url = "#{url}&page=b#{after_id}" if after_id
    response = Excon.get(url, headers: { 'User-Agent': 'walltaker.joi.how (by ailurus on e621)' })
    return nil if response.status != 200

    JSON.parse(response.body)['posts']
  end

  # Only allow a list of trusted parameters through.
  def porn_search_params
    params.permit(:tags, :after, :link)
  end
end
