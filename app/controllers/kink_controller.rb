class KinkController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :authorize, only: %i[add remove toggle_star]

  def users_kinks
    user = User.find_by_username(params['user_id'])
    @kinks = user.kinks if user.present?
    @kinks = [] unless user.present?

    @is_current_user = false
    @is_current_user = current_user.id == user.id if current_user && user
    @is_current_user = false unless current_user
  end

  def show
    @kink = Kink.find(params['id'])
    @users = @kink.users.order(updated_at: :desc).where.not(id: current_user&.id)
  end

  def search_kinks
    @link = Link.find(params[:link_id])
    return redirect_to root_path unless @link

    @user = @link.user
    @kinks = @user.kinks if @user.present?
    @kinks = [] unless @user.present?
  end

  def test_on_e621
    kink = Kink.find(params['id'])
    kink.test_on_e621 if kink

    if kink.works_on_e621?
      render turbo_stream: turbo_stream.update((dom_id(kink) + '_e621_status'), partial: 'kink/e621_status', locals: { kink: })
    else
      render turbo_stream: turbo_stream.update((dom_id(kink) + '_e621_status'), partial: 'kink/e621_status', locals: { kink:, failed: true })
    end
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
        kink.valid?
        redirect_to user_kinks_path(current_user.username), alert: kink.errors.full_messages.first
      end
    else
      kink = current_user.kinks.build
      kink.name = kink_name

      begin
        if kink.save
          @kink = kink
          render 'update'
        else
          redirect_to user_kinks_path(current_user.username), alert: kink.errors.full_messages.first
        end
      rescue
        redirect_to user_kinks_path(current_user.username), alert: kink.errors.full_messages.first
      end
    end
  end

  def toggle_star
    @kink = Kink.find(params['id'])

    if @kink
      kink_haver = @kink.had_by(current_user)

      if @kink.had_by(current_user)
        result = kink_haver.toggle_star
        redirect_to user_kinks_path(current_user.username), alert: kink_haver.errors.full_messages.join("\n") unless result
      else
        redirect_to user_kinks_path(current_user.username), alert: 'Something went wrong'
      end
    else
      redirect_to user_kinks_path(current_user.username), alert: 'Kink missing'
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
