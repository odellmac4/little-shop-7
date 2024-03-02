class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :bulk_discount_items
  has_many :bulk_discounts, through: :bulk_discount_items

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: { greater_than: 0, only_integer: true }


  enum status: {
  Disable: 0,
  Enable: 1
  }

  def change_status(status)
    if status == "Enable"
      update(status: 1)
    elsif status == "Disable"
      update(status: 0)
    end
  end

  def top_date
        top_selling_date =  self.invoices
                             .joins(:transactions)
                             .where(transactions: { result: 'success' })
                             .group(:created_at)
                             .order(Arel.sql('SUM(invoice_items.quantity * invoice_items.unit_price) DESC, created_at DESC'))
                             .limit(1)
                             .pluck(:created_at)
                             .first

                             formatted_date = top_selling_date.strftime("%Y-%m-%d")
  end

end
