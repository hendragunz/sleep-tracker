class AddIndexForPerformance < ActiveRecord::Migration[8.0]
  def change
    add_index :users, :id
    add_index :users, :authentication_token
    add_index :sleep_logs, :sleep_at
    add_index :sleep_logs, :wakeup_at
    add_index :sleep_logs, :duration
    add_index :sleep_logs, :created_at
  end
end
