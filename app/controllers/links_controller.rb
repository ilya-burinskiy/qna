class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :find_link

  def destroy
    authorize! :destroy, @link
    @link.destroy if current_user.author?(@link.linkable)
  end

  private

  def find_link
    @link = Link.find(params[:id])
  end
end
