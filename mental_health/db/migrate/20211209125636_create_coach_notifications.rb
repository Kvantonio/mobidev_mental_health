class CreateCoachNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :coach_notifications do |t|
      t.references :coach, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.text :description
      t.boolean :status

      t.timestamps
    end
  end
end
