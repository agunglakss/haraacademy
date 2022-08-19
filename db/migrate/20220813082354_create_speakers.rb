class CreateSpeakers < ActiveRecord::Migration[7.0]
  def change
    create_table :speakers, id: :uuid do |t|
      t.string :full_name
      t.string :title
      t.text :description
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end
