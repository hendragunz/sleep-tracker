module Simple
  class V1::API < Grape::API
    version 'v1'

    helpers do
      def current_user
        @current_user ||= User.find_by_authentication_token(headers['access-token'])
      end

      def authenticated?
        return false if headers['access-token'].blank?
        current_user.present?
      end
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      error!("Data not found", 404)
    end

    desc 'Return a test API Response'
    get :ping do
      { hello: :world }
    end

    desc 'Return your authenticated user'
    get :who do
      error!("You're not authorized", 401) unless authenticated?
      { you: current_user.email_address }
    end


    mount Simple::V1::Auth
    mount Simple::V1::Follows
  end
end
