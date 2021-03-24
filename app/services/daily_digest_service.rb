class DailyDigestService
  def self.call
    new.call
  end

  def call
    send_digest
  end

  private

  def send_digest
    User.find_each do |user|
      DailyDigestMailer.digest(user).deliver_later
    end
  end
end
