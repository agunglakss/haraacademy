class CreateVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :videos, id: :uuid do |t|
      t.string :subject
      t.string :url_video
      t.references :course, type: :uuid, index: true, foreign_key: true
      t.timestamps
    end
  end
end
