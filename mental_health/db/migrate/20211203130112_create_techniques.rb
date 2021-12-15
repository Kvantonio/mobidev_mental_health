class CreateTechniques < ActiveRecord::Migration[6.1]
  def change
    create_table :techniques do |t|
      t.string :title, index: { unique: true }
      t.text :description
      t.string :age_range
      t.integer :gender
      t.integer :duration

      t.timestamps
    end
  end
end
