class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: [:index, :create]
  before_action :find_answer, only: [:show, :update, :destroy]

  authorize_resource

  def index
    @question_answers = @question.answers
    render json: @question_answers, each_serializer: QuestionAnswersListSerializer::AnswerSerializer
  end

  def show
    render json: @answer, serializer: AnswerSerializer
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_resource_owner

    if @answer.save
      render json: @answer, serializer: AnswerSerializer
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer, serializer: AnswerSerializer
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  def destroy
    @answer.destroy
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, 
      files: [], links_attributes: [:name, :url, :id, :_destroy])
  end
end
