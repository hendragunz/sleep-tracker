module Simple
  class V1::Follows < Grape::API

    before {
      error!("You're not authorized", 401) unless authenticated?
    }

    resources :follows do
      # get do
      #   { yes: "it works" }
      # end

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
    end
  end
end
