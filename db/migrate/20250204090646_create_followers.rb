class CreateFollowers < ActiveRecord::Migration[8.0]
  def change
    create_table :followers do |t|
      t.references :followable, index: true
      t.references :follower, index: true
      t.timestamps
    end
  end
end
