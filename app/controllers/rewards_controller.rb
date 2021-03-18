class RewardsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def index
    @rewards = current_user.earned_rewards
  end
end
