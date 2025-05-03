class UserWakeUpJob
  include Sidekiq::Job

  sidekiq_options queue: "critical"

  def perform(user_id, wakeup_at)
    return unless user.sleep?
    ActiveRecord::Base.transaction do
      user.sleep_logs.create!(sleep_at: user.sleep_at, wakeup_at: wakeup_at)
      user.update!(sleep_at: nil)
    end
  end
end
