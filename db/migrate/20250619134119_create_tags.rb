class CreateTags < ActiveRecord::Migration[7.2]
  def change
    create_table :tags do |t|
      t.string :rails
      t.string :g
      t.string :model
      t.string :Tag
      t.string :name

      t.timestamps
    end
  end
end
