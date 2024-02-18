class KinkController < ApplicationController
  before_action :authorize, only: %i[add remove]

  def users_kinks
    user = User.find_by_username(params['user_id'])
    @kinks = user.kinks if user.present?
    @kinks = [] unless user.present?

    @is_current_user = current_user.id == user.id if current_user
    @is_current_user = false unless current_user
  end


  def show
    @kink = Kink.find(params['id'])
    @users = @kink.users.order(updated_at: :desc).where.not(id: current_user&.id)
  end

  def new
    @kink = current_user.kinks.new
  end

  def update
    kink_name = kink_params['name']

    kink = Kink.find_by_name kink_name
    if kink
      begin
        current_user.kinks << kink

        @kink = kink
        render 'update'
      rescue
        render turbo_stream: ""
      end
    else
      kink = current_user.kinks.build
      kink.name = kink_name

      begin
        if kink.save
          @kink = kink
          render 'update'
        else
          raise
        end
      rescue
        redirect_to user_kinks_path(current_user.username), alert: kink.errors.full_messages.first
      end
    end
  end

  def remove
    kink = Kink.find(params['id'])

    if kink
      @kink = kink
      current_user.kinks.delete kink
    else
      redirect_to user_kinks_path(current_user.username), alert: 'Something went wrong'
    end
  end

  private

  def kink_params
    params.require(:kink).permit(:name)
  end
end
