class CreatePaymentLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_logs, id: :uuid do |t|
      t.string :status
      t.references :order, type: :uuid, index: true, foreign_key: true
      t.string :payment_type
      t.json :raw_respone
      t.timestamps
    end
  end
end
