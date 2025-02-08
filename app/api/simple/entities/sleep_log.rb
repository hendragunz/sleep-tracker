module Simple
  module Entities
    class SleepLog < Grape::Entity
      root 'sleep_logs', 'sleep_log'

      format_with(:iso_timestamp) { |dt| dt.iso8601 }

      expose :id
      expose :duration

      with_options(format_with: :iso_timestamp) do
        expose :sleep_at
        expose :wakeup_at
      end
    end
  end
end
