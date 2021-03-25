class QuestionSubscribersNotifier
  def self.call(question)
    new(question).call
  end

  def initialize(question)
    @question = question
  end

  def call
    notify_question_subscribers
  end

  private

  def notify_question_subscribers
    question_subscribers = User.joins(:question_subscriptions).where(
      question_subscriptions: { question: @question }
    )

    question_subscribers.each do |subscriber|
      QuestionSubscribersMailer.notify(subscriber, @question)
    end
  end
end
