class CreateHashtags < ActiveRecord::Migration[7.2]
  def change
    create_table :hashtags do |t|
      t.string :name

      t.timestamps
    end
    add_index :hashtags, :name, unique: true
  end
end