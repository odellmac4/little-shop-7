class DropBulkDiscountsItems < ActiveRecord::Migration[7.1]
  def change
    drop_table :bulk_discounts_items
  end
end
