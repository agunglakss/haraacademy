class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories, id: :uuid do |t|
      t.string :name, null: false
      t.string :icon
      t.integer :sequence
      t.string :color
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end
