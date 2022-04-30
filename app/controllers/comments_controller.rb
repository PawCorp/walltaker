class CommentsController < ApplicationController
  before_action :set_link, only: %i[ new create ]

  # GET /links/1/comments
  def index
    @comments = Comment.all.where(link_id: params['link_id'])
  end

  # GET /links/1/comments/new
  def new
    @comment = Comment.new
  end

  # POST /comments or /comments.json
  def create
    @comment = Comment.new(comment_params)
    @comment.link_id = @link.id
    @comment.user_id = current_user.id

    if @comment.save
      redirect_to new_link_comment_url(@link)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def set_link
      @link = Link.find(params[:link_id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:content)
    end
end
