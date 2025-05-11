require "grape-swagger"

module Simple
  class API < Grape::API
    format :json
    prefix :api


    helpers do
    end

    mount Simple::V1::API => "/"
    add_swagger_documentation
  end
end
