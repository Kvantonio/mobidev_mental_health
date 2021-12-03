class CreateSocialNetworks < ActiveRecord::Migration[6.1]
  def change
    create_table :social_networks do |t|
      t.text :title
      t.references :coach, null: false, foreign_key: true

      t.timestamps
    end
  end
end
