module Simple
  class API < Grape::API
    format :json
    prefix :api


    helpers do
    end

    mount Simple::V1::API => "/"
  end
end
