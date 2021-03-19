class AttachmentsController < ApplicationController
  before_action :find_file
  before_action :authenticate_user!
  
  def destroy
    authorize! :destroy, @file
    @file.purge if current_user.author?(@file.record)
  end

  private

  def find_file
    @file = ActiveStorage::Attachment.find(params[:id])
  end
end
