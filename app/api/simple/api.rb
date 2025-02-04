module Simple
  class API < Grape::API
    version 'v1'
    format :json
    prefix :api

    helpers do
    end

    get 'ping' do
      { 'hello': 'world' }  # Returns a JSON response with a greeting message.  #
    end
  end
end
