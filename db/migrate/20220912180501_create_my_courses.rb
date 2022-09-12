class CreateMyCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :my_courses, id: :uuid do |t|
      t.references :course, type: :uuid, index: true, foreign_key: true
      t.references :user, type: :uuid, index: true, foreign_key: true
      t.timestamps
    end
  end
end
