class AddWakeupAndSleepToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :sleep_at, :datetime
  end
end
