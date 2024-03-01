class AddHasDiscountToItems < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :has_discount, :boolean
  end
end
