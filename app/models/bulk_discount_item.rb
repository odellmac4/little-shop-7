class BulkDiscountItem < ApplicationRecord
    belongs_to :bulk_discount
    belongs_to :item

    def self.top_discount_for_item(item_id, quantity)
        BulkDiscountItem.joins(:items)
                        .where(items: { id: item_id, has_discount: true} )
                        .joins(:bulk_discounts)
                        .select("bulk_discounts.percentage_discount AS discount_percentage")
                        .order("bulk_discounts.percentage_discount DESC")
                        .first
    end
end