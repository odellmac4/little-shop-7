class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  validates :status, presence: true

  enum status: {
    in_progress: 0,
    cancelled: 1,
    completed: 2
  }

  def self.incomplete_invoices
    InvoiceItem
    .joins(:invoice)
    .where(status: [0, 1])
    .group("invoice_items.id")
    .order('MIN(invoices.created_at) ASC')
  end

  def total_revenue
    invoice_items.sum('unit_price * quantity')
  end

  def blah
    
  end
end
