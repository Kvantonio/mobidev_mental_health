class CreateUserNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :user_notifications do |t|
      t.references :coach, null: true, foreign_key: true
      t.references :user, foreign_key: true
      t.text :description
      t.boolean :status

      t.timestamps
    end
  end
end
