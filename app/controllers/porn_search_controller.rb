class PornSearchController < ApplicationController
  def index

  end

  def search
    @page_number = porn_search_params[:page_number].to_i
    @page_number = 1 if @page_number == 0
    @link = Link.find(porn_search_params[:link]) if porn_search_params[:link]
    @posts = get_tag_results porn_search_params[:tags], porn_search_params[:after], porn_search_params[:before], @link
    @last_tags = porn_search_params[:tags]

    track :regular, :search_e621_on_link, search: porn_search_params[:tags]

    redirect_to :index if @posts.nil?
  end

  private

  # Only allow a list of trusted parameters through.
  def porn_search_params
    params.permit(:tags, :after, :before, :page_number, :link)
  end
end
