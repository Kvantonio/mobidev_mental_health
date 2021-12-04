class CreateRaitings < ActiveRecord::Migration[6.1]
  def change
    create_table :raitings do |t|
      t.belongs_to :user
      t.belongs_to :technique
      t.integer :like
      t.integer :dislike

      t.timestamps

      t.index [:user_id, :technique_id], unique: true
    end
  end
end
