module Simple
  class V1::Follows < Grape::API

    before {
      error!("You're not authorized", 401) unless authenticated?
    }

    resources :follows do
      desc "To return all folowing users"
      get do
        @follows = current_user.followees
        present @follows, with: Simple::Entities::Follow
      end

      desc "To follow user with given email address"
      params do
        requires :user, type: Hash do
          requires :email_address, type: String, desc: "Target user's email address to follow"
        end
      end
      post do
        target_email  = declared(params)['user']['email_address']
        target_user   = User.find_by(email_address: target_email)

        if target_user
          result = current_user.follow(target_user)
          present result, with: Simple::Entities::Follow
        else
          error!("The follow user with email address: #{target_email} is not exist", 404)
        end
      end


      desc "To return all followees - sleep activities ", {
        is_array: true,
        failures: [
          [400, 'Bad Request']
        ],
        summary: "Return all folowees sleep activities"
      }
      params do
        optional :from_date,  type: Date
        optional :to_date,    type: Date
      end
      get '/sleep_logs' do
        from_date     = declared(params)['from_date']
        to_date       = declared(params)['to_date']

        # logic to pull sleep logs data
        # from user's followees
        #
        followee_ids  = current_user.followees.map(&:followable_id)
        sleep_logs = SleepLog.where(user_id: followee_ids).includes(:user)
        sleep_logs = sleep_logs.where('created_at >=?', from_date)  if from_date.present?
        sleep_logs = sleep_logs.where('created_at <=?', to_date)    if to_date.present?


        present sleep_logs, with: Simple::Entities::SleepLog, user: true
      end
    end
  end
end
