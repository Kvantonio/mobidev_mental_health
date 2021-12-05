class CreateSteps < ActiveRecord::Migration[6.1]
  def change
    create_table :steps do |t|
      t.string :title
      t.text :body
      t.integer :number
      t.references :technique, null: false, foreign_key: true

      t.timestamps
    end
  end
end
