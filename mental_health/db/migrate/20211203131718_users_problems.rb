class UsersProblems < ActiveRecord::Migration[6.1]
  def change
    create_table :problems_users, id: false do |t|
      t.belongs_to :user
      t.belongs_to :problem
      t.timestamps
      t.index [:user_id, :problem_id], unique: true
    end
  end
end
