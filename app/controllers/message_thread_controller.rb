class MessageThreadController < ApplicationController
  def index
    @message_threads = MessageThread.includes(:users).where(users: { id: current_user.id })
  end

  def show
    message_thread_id = params['id']
    if message_thread_id
      @message_thread = MessageThread
                    .includes(:users, :messages)
                    .where(users: { id: current_user.id })
                    .find(message_thread_id)
    end
  end

  def new
  end

  def create
  end

  def destroy
  end

  def edit
  end

  def update
  end
end
