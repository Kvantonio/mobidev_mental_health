class CreateRatings < ActiveRecord::Migration[6.1]
  def change
    create_table :ratings do |t|
      t.belongs_to :user
      t.belongs_to :technique
      t.integer :mark

      t.timestamps

      t.index [:user_id, :technique_id], unique: true
    end
  end
end
