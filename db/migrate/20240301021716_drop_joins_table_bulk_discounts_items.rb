class DropJoinsTableBulkDiscountsItems < ActiveRecord::Migration[7.1]
  def change
    drop_table :joins_table_bulk_discounts_items, if_exists: true
  end
end
