class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.name
      t.timestamps
    end
  end
end
