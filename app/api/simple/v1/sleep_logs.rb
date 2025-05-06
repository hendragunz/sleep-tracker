module Simple
  class V1::SleepLogs < Grape::API
    before {
      error!("You're not authorized", 401) unless authenticated?
    }

    resources :sleep_logs do
      desc "Return all Sleep / Wake Up activity logs from current user", {
        is_array: true,
        failures: [
          [ 400, "Bad Request" ]
        ],
        summary: "Return all current user sleep activities"
      }
      params do
        optional :from_date,  type: Date
        optional :to_date,    type: Date
      end
      paginate per_page: 10, max_per_page: 100, enforce_max_per_page: true
      get "me" do
        from_date     = declared(params)["from_date"]
        to_date       = declared(params)["to_date"]

        # logic to pull sleep logs data
        sleep_logs = current_user.sleep_logs
        sleep_logs = sleep_logs.where("created_at >=?", from_date)  if from_date.present?
        sleep_logs = sleep_logs.where("created_at <=?", to_date)    if to_date.present?
        sleep_logs = paginate sleep_logs

        present sleep_logs, with: Simple::Entities::SleepLog
      end


      desc "To return all followees - sleep activities ", {
        is_array: true,
        failures: [
          [ 400, "Bad Request" ]
        ],
        summary: "Return all folowees sleep activities"
      }
      params do
        optional :from_date,  type: Date
        optional :to_date,    type: Date
      end
      paginate per_page: 10, max_per_page: 100, enforce_max_per_page: true
      get "/followees" do
        from_date     = declared(params)["from_date"]
        to_date       = declared(params)["to_date"]

        # logic to pull sleep logs data
        # from user's followees
        #
        sleep_logs = SleepLog.joins(user: :followers).where(followers: { follower_id: current_user.id }).includes(:user)
        sleep_logs = sleep_logs.where("created_at >=?", from_date)  if from_date.present?
        sleep_logs = sleep_logs.where("created_at <=?", to_date)    if to_date.present?
        sleep_logs = paginate sleep_logs

        present sleep_logs, with: Simple::Entities::SleepLog, user: true
      end
    end
  end
end
