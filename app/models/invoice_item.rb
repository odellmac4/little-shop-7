class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  enum status: {
    pending: 0,
    packaged: 1,
    shipped: 2
  }

  def total_price
    quantity * unit_price
  end

  def discounted_unit_price
    require 'pry'; binding.pry

    if top_discount.present?
       discounted_price = unit_price * (1 - top_discount.percentage_discount)
       discounted_price.round(2)
    else
       unit_price
    end
  end

  def top_discount
    BulkDiscount
                .joins(:items)
                .select("bulk_discounts.*")
                .where("bulk_discounts.quantity_threshold <= ?", self.quantity)
                .order("bulk_discounts.percentage_discount DESC")
                .first
  end
end
