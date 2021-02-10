class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      redirect_to question_path(question), notice: 'Your answer successfully created.'
    else
      render 'questions/show'
    end
  end

  def edit; end

  def update
    if answer.update(answer_params)
      redirect_to question_path(question)
    else
      render :edit
    end
  end

  def destroy
    answer.destroy if current_user.author?(answer)
    redirect_to question_path(question)
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
