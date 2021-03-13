class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    find_commentable
    @comment = @commentable.comments.create(
      comment_params.merge(author: current_user)
    )
  end

  private

  def find_commentable
    if params[:question_id]
      @commentable = Question.find(params[:question_id])
    elsif params[:answer_id]
      @commentable = Answer.find(params[:answer_id])
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
