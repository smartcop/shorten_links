class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :ip_address
      t.string :user_agent
      t.references :url, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
