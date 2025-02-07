module Simple
  module Entities
    class Follow < Grape::Entity

      root 'follows', 'follow'

      format_with(:iso_timestamp) { |dt| dt.iso8601 }
      expose :id
      expose :email_address do |obj, options|
        obj.followable.email_address
      end

      with_options(format_with: :iso_timestamp) do
        expose :created_at
        expose :updated_at
      end
    end
  end
end
