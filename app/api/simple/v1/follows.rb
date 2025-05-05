module Simple
  class V1::Follows < Grape::API
    before {
      error!("You're not authorized", 401) unless authenticated?
    }

    resources :follows do
      desc "To return all folowing users"
      paginate per_page: 10, max_per_page: 100, enforce_max_per_page: true
      get do
        @follows = paginate current_user.followees
        present @follows, with: Simple::Entities::Follow
      end

      desc "To follow user with given email address"
      params do
        requires :user, type: Hash do
          requires :email_address, type: String, desc: "Target user's email address to follow"
        end
      end
      post do
        target_email  = declared(params)["user"]["email_address"]
        target_user   = User.find_by(email_address: target_email)

        if target_user
          result = current_user.follow(target_user)
          present result, with: Simple::Entities::Follow
        else
          error!("The follow user with email address: #{target_email} is not exist", 404)
        end
      end

      desc "To unfollow user with given email address", {
        is_array: false,
        failures: [
          [ 400, "Bad Request" ]
        ],
        summary: "To unfollow user"
      }
      params do
        requires :user, type: Hash do
          requires :email_address, type: String, desc: "Target user's email address to unfollow"
        end
      end
      delete do
        target_email  = declared(params)["user"]["email_address"]
        target_user   = User.find_by(email_address: target_email)

        if target_user
          if current_user.unfollow(target_user)
            status :no_content
          else
            error!("Not following user with email address: #{target_email}", 404)
          end
        else
          error!("The follow user with email address: #{target_email} is not exist", 404)
        end
      end
    end
  end
end
