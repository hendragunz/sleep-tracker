class UserWakeUpJob
  include Sidekiq::Job

  sidekiq_options queue: "critical",
                  lock: :until_executed

  def perform(user_id, wakeup_at)
    user = User.find_by(id: user_id)
    return unless user.sleep?

    ActiveRecord::Base.transaction do
      user.sleep_logs.create!(sleep_at: user.sleep_at, wakeup_at: Time.at(wakeup_at))
      user.update!(sleep_at: nil)
    end
  end
end
