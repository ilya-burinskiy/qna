class CommentsController < ApplicationController
  before_action :authenticate_user!

  after_action :publish_comment, only: [:create]
  
  authorize_resource

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

  def publish_comment
    return if @comment.errors.any?

    question_id = @comment.commentable.is_a?(Question) ? @comment.commentable.id : @comment.commentable.question.id
    ActionCable.server.broadcast "question_#{question_id}/comments", @comment
  end
end
