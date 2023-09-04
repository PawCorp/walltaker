class SearchController < ApplicationController
  PAGE_SIZE = 5

  def index
  end

  def results
    @query = params[:q] || ''
    @page = (params[:page] || '1').to_i

    all_results = Link.search_positive(@query).is_public
    @total = Rails.cache.fetch("v1/searchtotals/#{@query}", expires_in: 4.minutes) { all_results.count }
    @has_next_page = (@total - (@page * PAGE_SIZE)) > 0
    result_link_ids = Rails.cache.fetch("v1/searchpage/#{@query}/#{@page}", expires_in: 4.minutes) { all_results.limit(PAGE_SIZE).offset((@page - 1) * PAGE_SIZE).pluck(:id) }
    @links = Link.where(id: result_link_ids)
  end
end
