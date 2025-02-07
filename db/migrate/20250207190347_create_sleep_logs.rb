class CreateSleepLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :sleep_logs do |t|
      t.references :user, index: true
      t.datetime  :sleep_at
      t.datetime  :wakeup_at
      t.integer   :duration
      t.timestamps
    end
  end
end
