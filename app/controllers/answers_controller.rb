class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!

  def create
    @answer = question.answers.create(answer_params.merge({ author: current_user }))
  end

  def update
    answer.update(answer_params) if current_user.author?(answer)
  end

  def destroy
    answer.destroy if current_user.author?(answer)
  end

  def best
    if current_user.author?(answer.question)
      answer.become_best
    end
  end

  private

  helper_method :answer, :question

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end

  def question
    params[:question_id] ? Question.find(params[:question_id]) : answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, 
      files: [], links_attributes: [:name, :url, :id, :_destroy])
  end
end
