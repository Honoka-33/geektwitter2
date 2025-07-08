class CreateHashtags < ActiveRecord::Migration[7.2]
  def change
    create_table :hashtags do |t|
      t.string :name, null: false, unique: true

      t.timestamps
    end
    add_index :hashtags, :name, unique: true
  end
end
