module Simple
  class API < Grape::API
    version 'v1'
    format :json
    prefix :api


    helpers do
    end

    mount Simple::V1::API => '/'
  end
end
