class CreateCertificates < ActiveRecord::Migration[6.1]
  def change
    create_table :certificates do |t|
      t.text :title
      t.references :coach, null: false, foreign_key: true

      t.timestamps
    end
  end
end
