module Simple
  class V1::Track < Grape::API

    before {
      error!("You're not authorized", 401) unless authenticated?
    }

    resource :track do
      desc "Return all Sleep / Wake Up activity logs"
      get do
        present current_user.sleep_logs, with: Simple::Entities::SleepLog
      end

      desc "Track time when go to sleep"
      post "/sleep" do
        error!("You can't sleep while you already sleeping :-) ", 404)  if current_user.sleep?
        sleep_log = current_user.sleep_logs.create(sleep_at: Time.now)
        present sleep_log, with: Simple::Entities::SleepLog
      end

      desc "Track time when wake up"
      post "/wakeup" do
        error!("You didn't sleep yet :-) ", 404)  if current_user.awake?
        last_sleep_log = current_user.sleep_logs.latest.first
        last_sleep_log.update(wakeup_at: Time.now)
        present last_sleep_log, with: Simple::Entities::SleepLog
      end
    end
  end
end
