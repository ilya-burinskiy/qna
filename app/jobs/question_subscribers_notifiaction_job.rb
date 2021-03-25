class QuestionSubscribersNotifiactionJob < ApplicationJob
  queue_as :default

  def perform(question)
    QuestionSubscribersNotifier.call(question)
  end
end
