class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders, id: :uuid do |t|
      t.string :status
      t.references :course, type: :uuid, index: true, foreign_key: true
      t.references :user, type: :uuid, index: true, foreign_key: true
      t.string :snap_url
      t.json :metadata
      t.timestamps
    end
  end
end
