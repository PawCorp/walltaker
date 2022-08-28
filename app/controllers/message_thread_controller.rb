class MessageThreadController < ApplicationController
  before_action :set_message_thread, only: %i[show send_message edit remove_user add_user]

  def index
    @message_threads = MessageThread.includes(:users).where(users: { id: current_user.id })
  end

  def show
    @new_message = @message_thread.messages.new
  end

  def send_message
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
    message_thread = MessageThread.new
    message_thread.users << current_user
    message_thread.save
    redirect_to edit_message_thread_path message_thread
  end

  def create
    # To be implemented later, for now, create happen with different actions
  end

  def destroy
  end

  def edit
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
    user = User.find params['user_id']
    if user && @message_thread
      @message_thread.users.delete user
      redirect_to edit_message_thread_path @message_thread
    end
  end

  def add_user
    user = User.find params['user_id']
    if user && @message_thread
      @message_thread.users << user
      Notification.create user: user, notification_type: :added_to_message_thread, text: "#{current_user.username} added you to a message thread.", link: message_thread_path(@message_thread)
      redirect_to edit_message_thread_path @message_thread
    end
  end

  def update

  end

  private

  def set_message_thread
    message_thread_id = params['id']
    if message_thread_id
      begin
        @message_thread = MessageThread.includes(:users).where(users: { id: current_user.id }).find(message_thread_id)
      rescue
        track :nefarious, :tried_to_access_unknown_thread, user: current_user, thread_id: message_thread_id
        redirect_to message_thread_index_path, alert: 'Thread was not found, or you were removed from it.'
      end
    end
  end
end
