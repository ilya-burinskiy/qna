class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new; end

  def create
    @question = Question.new(question_params)
    @question.author = current_user

    if @question.save
      redirect_to question_path(@question), notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    question.update(question_params) if current_user.author?(question)
  end

  def destroy
    question.destroy if current_user.author?(question)
    redirect_to questions_path
  end

  private

  helper_method :question

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
