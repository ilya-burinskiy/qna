class QuestionSubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    authorize! :create, QuestionSubscription
    @question = Question.find(params[:question_id])
    @subscription = current_user.subscribe_for_question(@question)
  end

  def destroy
    @subscription = QuestionSubscription.find(params[:id])
    authorize! :destroy, @subscription
    current_user.unsubscribe_from_question(@subscription.question)
  end
end
