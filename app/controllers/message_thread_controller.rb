class MessageThreadController < ApplicationController
  def index
    @message_threads = MessageThread.includes(:users).where(users: { id: current_user.id })
  end

  def show
    message_thread_id = params['id']
    if message_thread_id
      @message_thread = MessageThread.includes(:users).where(users: { id: current_user.id }).find(message_thread_id)
      @new_message = @message_thread.messages.new
    end
  end

  def send_message
    message_thread_id = params['id']
    message = params['message']
    if message_thread_id
      @message_thread = MessageThread.includes(:users).where(users: { id: current_user.id }).find(message_thread_id)
      @new_message = @message_thread.messages.new
      @new_message.content = message['content']
      @new_message.from_user = current_user
      response = @new_message.save

      if (!response)
        track :error, :message_could_not_be_saved, message: @new_message, thread: @message_thread
      else
        redirect_to message_thread_path message_thread_id
      end
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
