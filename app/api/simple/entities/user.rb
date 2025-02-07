module Simple
  module Entities
    class User < Grape::Entity
      root 'users', 'user'

      # format_with(:iso_timestamp) { |dt| dt.iso8601 }
      # expose :id
      expose :email_address
      expose :name

      # with_options(format_with: :iso_timestamp) do
      #   expose :created_at
      #   expose :updated_at
      # end
    end
  end
end
