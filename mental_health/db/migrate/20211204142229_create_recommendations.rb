class CreateRecommendations < ActiveRecord::Migration[6.1]
  def change
    create_table :recommendations do |t|
      t.belongs_to :coach
      t.belongs_to :user
      t.belongs_to :technique
      t.integer :current_step
      t.timestamp :started_at
      t.timestamp :finished_at

      t.timestamps

      t.index [:user_id, :technique_id], unique: true
    end
  end
end
