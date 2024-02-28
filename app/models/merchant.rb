class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices, through: :items
  has_many :customers, through: :invoices
  has_many :transactions, through: :customers
  has_many :invoice_items, through: :items

  validates :name, presence: true
  
  # SELECT customers.*, COUNT(transactions.id) as "transaction_count"
  # FROM transactions
  # INNER JOIN invoices ON transactions.invoice_id = invoices.id
  # INNER JOIN invoice_items ON invoices.id = invoice_items.invoice_id
  # INNER JOIN items ON invoice_items.item_id = items.id
  # INNER JOIN customers ON customers.id = invoices.customer_id
  # WHERE items.merchant_id = 1 AND transactions.result = 'success'
  # GROUP BY customers.id
  # ORDER BY COUNT(transactions.id) DESC
  # LIMIT 5
  def top_customers
    customers
      .joins(:transactions)
      .where(transactions: { result: "success" })
      .group("customers.id")
      .order("count(transactions.id) DESC")
      .limit(5)
      .select("customers.*", "COUNT(transactions.id) AS transaction_count")
  end
  
  def items_ready_to_ship
    invoice_items
      .joins(:invoice)
      .where(invoice_items: {status: "packaged"})
      .order('invoices.created_at ASC')
  end

  def calculate_top_items
    self.items
        .select('items.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS total_revenue')
        .joins(:invoice_items)
        .joins(invoices: :transactions) # Change 'invoice' to 'invoices'
        .where(transactions: { result: 'success' })
        .group('items.id')
        .order('total_revenue DESC')
        .limit(5)
  end

  # US 31
  # doesn't work
  # def self.top_selling_merchants_by_date
  #   joins(invoices: :transactions)
  #     .where(transactions: { result: 'success' })
  #     .group('merchants.id', 'invoices.created_at')
  #     .select('merchants.*, COUNT(invoices.id) AS invoice_count, MAX(invoices.created_at) AS best_day')
  #     .order('invoice_count DESC, best_day DESC')
  #     .limit(5)
  # end  
end
