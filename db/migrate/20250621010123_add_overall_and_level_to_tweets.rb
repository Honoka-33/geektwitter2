class AddOverallAndLevelToTweets < ActiveRecord::Migration[7.2]
  def change
    add_column :tweets, :overall, :integer
    add_column :tweets, :level, :integer
  end
end
