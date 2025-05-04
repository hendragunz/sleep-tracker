module Simple
  class V1::Track < Grape::API
    before {
      error!("You're not authorized", 401) unless authenticated?
    }

    resource :track do
      desc "Return all Sleep / Wake Up activity logs"
      paginate per_page: 10, max_per_page: 100, enforce_max_per_page: true
      get do
        @sleep_logs = paginate current_user.sleep_logs
        present @sleep_logs, with: Simple::Entities::SleepLog
      end

      desc "Track time when go to sleep"
      post "/sleep" do
        error!("You can't sleep while you already sleeping :-) ", 404)  if current_user.sleep?
        time = Time.now
        current_user.sleep!(time)
        present({
          sleep_log: {
            sleep_at: time
          }
        })
      end

      desc "Track time when wake up"
      post "/wakeup" do
        error!("You didn't sleep yet :-) ", 404)  unless current_user.sleep?
        wakeup_at = Time.now.to_i
        job_id = UserWakeUpJob.perform_async(current_user.id, wakeup_at)

        if job_id.present?
          present({
            sleep_log: {
              sleep_at: current_user.sleep_at, wakeup_at: wakeup_at
            }
          })
        else
          error!("Please try again later, recording your wake-up time still on-progress", 404)
        end
      end
    end
  end
end
