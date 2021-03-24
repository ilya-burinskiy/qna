class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :find_question, only: [:show, :update, :destroy]

  authorize_resource
 
  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsListSerializer::QuestionSerializer
  end

  def show
    render json: @question, serializer: QuestionSerializer
  end

  def create
    @question = Question.new(question_params)
    @question.author = current_resource_owner

    if @question.save
      render json: @question, serializer: QuestionSerializer
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      render json: @question, serializer: QuestionSerializer
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
      links_attributes: [:name, :url, :id, :_destroy],
      reward_attributes: [:name, :image]
    )
  end
end
