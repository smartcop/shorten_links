class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.text :full_url
      t.string :short_url
      t.integer :visits
      t.timestamps null: false
    end
  end
end
