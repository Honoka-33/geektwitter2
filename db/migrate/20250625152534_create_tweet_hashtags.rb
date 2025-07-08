class CreateTweetHashtags < ActiveRecord::Migration[7.2]
  def change
    create_table :tweet_hashtags do |t|
      t.references :tweet, null: false, foreign_key: true
      t.references :hashtag, null: false, foreign_key: true

      t.timestamps
    end
    add_index :tweet_hashtags, [:tweet_id, :hashtag_id], unique: true
  end
end
