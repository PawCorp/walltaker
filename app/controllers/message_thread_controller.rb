class MessageThreadController < ApplicationController
  def index
    @message_threads = MessageThread.includes(:users).where(users: { id: current_user.id })
  end

  def show
    set_message_thread
    if @message_thread
      @new_message = @message_thread.messages.new
    end
  end

  def send_message
    set_message_thread
    message = params['message']
    if @message_thread && (message['content'].class == String) && (message['content'].length > 0)
      @new_message = @message_thread.messages.new
      @new_message.content = message['content']
      @new_message.from_user = current_user
      response = @new_message.save

      if (!response)
        track :error, :message_could_not_be_saved, message: @new_message, thread: @message_thread
      else
        @message_thread.users.all.each do |user|
          if user.username != current_user.username
            Notification.create user: user, notification_type: :new_message, text: "#{current_user.username}: #{message['content'].truncate 24}", link: message_thread_path(@message_thread)
          end
        end
        redirect_to message_thread_path @message_thread
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
    set_message_thread
    @current_participants = @message_thread.users
    @friendships = Friendship.all.where(sender: current_user)
                             .or(Friendship.all.where(receiver: current_user))
                             .where(confirmed: true).and(
      Friendship.all.where.not(sender: @current_participants).or(
        Friendship.all.where.not(receiver: @current_participants)
      )
    )
  end

  def remove_user
    set_message_thread
    user = User.find params['user_id']
    if user && @message_thread
      @message_thread.users.delete user
      redirect_to edit_message_thread_path @message_thread
    end
  end

  def add_user
    set_message_thread
    user = User.find params['user_id']
    if user && @message_thread
      @message_thread.users << user
      Notification.create user: user, notification_type: :added_to_message_thread, text: "#{current_user.username} added you to a message thread.", link: message_thread_path(@message_thread)
      redirect_to edit_message_thread_path @message_thread
    end
  end

  def update
    # To be implemented later, for now, updates happen with different actions
  end

  private

  def set_message_thread
    message_thread_id = params['id']
    if message_thread_id
      @message_thread = MessageThread.includes(:users).where(users: { id: current_user.id }).find(message_thread_id)
    end
  end
end
