class CreateBulkDiscounts < ActiveRecord::Migration[7.1]
  def change
    create_table :bulk_discounts do |t|
      t.float :percentage_discount
      t.integer :quantity_threshold
      t.bigint :merchant_id

      t.timestamps
    end
  end
end
