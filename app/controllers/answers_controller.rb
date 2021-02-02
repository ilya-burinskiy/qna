class AnswersController < ApplicationController
  def show; end

  def new; end

  def create
    @answer = question.answers.new(answer_params)

    if @answer.save
      redirect_to answer_path(@answer)
    else
      render :new
    end
  end

  def update
    if answer.update(answer_params)
      redirect_to answer_path(@answer)
    else
      render :edit
    end
  end

  private

  helper_method :answer

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  def question
    Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
