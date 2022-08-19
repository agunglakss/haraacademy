class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses, id: :uuid do |t|
      t.string :title, :unique => true
      t.string :slug
      t.integer :price
      t.integer :discount
      t.date :date
      t.integer :sort, default: 0 # playback or live
      t.integer :status, default: 0 #[draft, published]
      t.string :created_by
      t.string :updated_by
      t.references :category, type: :uuid, index: true, foreign_key: true
      t.references :speaker, type: :uuid, index: true, foreign_key: true
      t.timestamps
    end
    
  end
end
