class PornSearchController < ApplicationController
  def index

  end

  def search
    @page_number = porn_search_params[:page_number].to_i
    @page_number = 1 if @page_number == 0

    @tags = porn_search_params[:tags]
    @after = porn_search_params[:after]
    @before = porn_search_params[:before]

    if porn_search_params[:link].present?
      @link = Link.find(porn_search_params[:link])
      @posts = get_tag_results porn_search_params[:tags], porn_search_params[:after], porn_search_params[:before], @link
      @last_tags = porn_search_params[:tags]

      track :regular, :search_e621_on_link, search: porn_search_params[:tags]

      redirect_to :index if @posts.nil?

    elsif porn_search_params[:message_thread].present?
      @message_thread = MessageThread.find(porn_search_params[:message_thread])
      @posts = get_tag_results porn_search_params[:tags], porn_search_params[:after], porn_search_params[:before], nil
      @last_tags = porn_search_params[:tags]
    else
      redirect_to :index
    end
  end

  def send_message_and_return
    content = porn_search_params[:message]
    message_thread = MessageThread.find(porn_search_params[:message_thread])
    new_message = message_thread.messages.new
    new_message.content = content
    new_message.from_user = current_user
    response = new_message.save
    redirect_to porn_search_params[:return_to_path]
  end

  private

  # Only allow a list of trusted parameters through.
  def porn_search_params
    params.permit(:tags, :after, :before, :page_number, :link, :message_thread, :message, :return_to_path)
  end
end
