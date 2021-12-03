class UsersProblems < ActiveRecord::Migration[6.1]
  def change
    create_table :problems_users, id: false do |t|
      t.belongs_to :user
      t.belongs_to :problem
      t.timestamps
    end
  end
end
