class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @new_questions = Question.asked_today
    mail to: user.email
  end
end
