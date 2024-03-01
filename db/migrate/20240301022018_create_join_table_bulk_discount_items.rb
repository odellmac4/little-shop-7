class CreateJoinTableBulkDiscountItems < ActiveRecord::Migration[7.1]
  def change
    create_join_table :bulk_discounts, :items do |t|
      # t.index [:bulk_discount_id, :item_id]
      # t.index [:item_id, :bulk_discount_id]
    end
  end
end
