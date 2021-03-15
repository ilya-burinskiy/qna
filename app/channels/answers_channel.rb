class AnswersChannel < ApplicationCable::Channel
  def follow
    stream_from "question_#{params[:question_id]}/answers"
  end
end
