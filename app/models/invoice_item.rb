class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  enum status: {
    pending: 0,
    packaged: 1,
    shipped: 2
  }

  def discounted_unit_price
    # float (percentage)
    bulk_discount = item.bulk_discounts.find_by(quantity)

    if quantity >= item.bulk_discounts.quantity_threshold
      
    end
  end
end
