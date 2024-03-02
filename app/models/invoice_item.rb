class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  enum status: {
    pending: 0,
    packaged: 1,
    shipped: 2
  }

  def discounted_unit_price
    bulk_discount = item.bulk_discounts.find_by(quantity) # float

    if quantity >= item.bulk_discounts.quantity_threshold
      # easy way to work with percentages!!!
      unit_price * (1 - bulk_discount.percentage_discount) 
    else
      unit_price
    end
  end
end
