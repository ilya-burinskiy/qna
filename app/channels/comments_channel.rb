class CommentsChannel < ApplicationCable::Channel
  def follow
    stream_from "question_#{params[:question_id]}/comments"
  end
end
