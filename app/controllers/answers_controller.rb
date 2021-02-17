class AnswersController < ApplicationController
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
    answer.become_best if current_user.author?(answer.question)
  end

  private

  helper_method :answer, :question

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  def question
    params[:question_id] ? Question.find(params[:question_id]) : answer.question
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
