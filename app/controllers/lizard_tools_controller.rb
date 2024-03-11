class LizardToolsController < ApplicationController
  before_action :authorize_with_admin_or_lizard
  def index
  end

  def warren
    @links = Link.is_online.joins(:user).where(user: {mascot: 'warren'}).group_by {|link| !!link.user.pervert}
    @name = 'Warren'
    render 'lizard_browse'
  end

  def ki
    @links = Link.is_online.joins(:user).where(user: {mascot: 'ki'}).group_by {|link| !!link.user.pervert}
    @name = 'Ki'
    render 'lizard_browse'
  end

  def taylor
    @links = Link.is_online.joins(:user).where(user: {mascot: 'taylor'}).group_by {|link| !!link.user.pervert}
    @name = 'Taylor'
    render 'lizard_browse'
  end
end
