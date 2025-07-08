class CreatePresents < ActiveRecord::Migration[7.2]
  def change
    create_table :presents do |t|
      t.string :question

      t.timestamps
    end
  end
end
