class PornSearchController < ApplicationController
  def index

  end

  def search
    @posts = get_tag_results porn_search_params[:tags], porn_search_params[:after]
    @last_tags = porn_search_params[:tags]

    redirect_to :index if @posts.nil?
  end

  private

  def get_tag_results(tag_string, after)
    padded_tag_string = tag_string + ' score:>5 type:jpg type:png'
    tags = CGI.escape padded_tag_string
    url = "https://e621.net/posts.json?tags=#{tags}&limit=12"
    after_id = after.gsub(/\D/, '') if after
    url = "#{url}&page=b#{after_id}" if after_id
    response = Excon.get(url)
    return nil if response.status != 200

    JSON.parse(response.body)['posts']
  end

  # Only allow a list of trusted parameters through.
  def porn_search_params
    params.permit(:tags, :after)
  end
end
