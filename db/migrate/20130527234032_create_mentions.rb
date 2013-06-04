class CreateMentions < ActiveRecord::Migration
  def change
    create_table :mentions do |t|
      t.integer :location_id
      t.integer :tweet_id

      t.timestamps
    end
    add_index :mentions, :location_id
    add_index :mentions, [:location_id, :tweet_id], unique: true
  end
end
