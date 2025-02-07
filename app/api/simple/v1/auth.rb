module Simple
  class V1::Auth < Grape::API
    resources :auth do
      params do
        requires :user, type: Hash, documentation: { param_type: 'body' } do
          requires :email_address,  type: String, allow_blank: false
          requires :password,       type: String, allow_blank: false
        end
      end
      post do
        login_params = declared(params)['user']

        @user = User.authenticate_by(login_params)
        error!("User with given email address is not found", 401) if @user.blank?

        @user.generate_authentication_token!

        # return this information
        {
          name:           @user.name,
          email_address:  @user.email_address,
          access_token:   @user.authentication_token
        }
      end
    end
  end
end
