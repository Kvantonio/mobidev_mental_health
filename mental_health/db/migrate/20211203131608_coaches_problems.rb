class CoachesProblems < ActiveRecord::Migration[6.1]
  def change
    create_table :coaches_problems, id: false do |t|
      t.belongs_to :coach
      t.belongs_to :problem
      t.timestamps
    end
  end
end
