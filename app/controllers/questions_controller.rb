class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  after_action :publish_question, only: [:create]
  
  include Voted

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @comment = Comment.new
    @answer.links.new

    @subscription = QuestionSubscription.where(user: current_user, question: question).first
  end

  def new
    question.links.new
    question.build_reward
  end

  def create
    @question = Question.new(question_params)
    @question.author = current_user
    @question.reward.author = current_user if @question.reward
    
    if @question.save
      current_user.subscribe_for_question(@question)
      redirect_to question_path(@question), notice: 'Your question successfully created.'
    else
      @question.links.new
      @question.build_reward
      render :new
    end
  end

  def update
    authorize! :update, question
    question.update(question_params)
    @comment = Comment.new
  end

  def destroy
    authorize! :destroy, question
    question.destroy
    redirect_to questions_path
  end

  private

  helper_method :question

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
      links_attributes: [:name, :url, :id, :_destroy],
      reward_attributes: [:name, :image]
    )
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/questions_list_element',
        locals: { question: @question }
      )
    )
  end
end
