class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices, through: :items
  has_many :customers, through: :invoices
  has_many :transactions, through: :customers
  has_many :invoice_items, through: :items
  has_many :bulk_discounts

  validates :name, presence: true

  enum status: {
  disable: 0,
  enable: 1
  }
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

  def total_revenue
    invoice_items.sum('invoice_items.quantity * invoice_items.unit_price')
  end

  def self.top_merchants
    self.select('merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS total_revenue')
        .joins(:items)
        .joins(:invoice_items)
        .joins(invoices: :transactions)
        .where(transactions: { result: 'success' })
        .group('merchants.id', 'merchants.name')
        .order('total_revenue DESC')
        .limit(5)
  end

#   SELECT
#   DATE_TRUNC('day', invoices.created_at) AS created_at_day,
#   merchants.id,
#   SUM(invoice_items.quantity * invoice_items.unit_price) AS total_revenue
# FROM
#   invoices
# INNER JOIN invoice_items ON invoices.id = invoice_items.invoice_id
# INNER JOIN items ON invoice_items.item_id = items.id
# INNER JOIN merchants ON items.merchant_id = merchants.id
# INNER JOIN transactions ON transactions.invoice_id = invoices.id
# WHERE
#   transactions.result = 'success'
# GROUP BY
#   created_at_day,
#   merchants.id
# ORDER BY
#   total_revenue DESC
# LIMIT 1;

  def best_day
    self.invoices
        .joins(items: :invoice_items)
        .joins(:transactions)
        .where(transactions: { result: 'success' })
        .group("created_at_day")
        .order(Arel.sql("SUM(invoice_items.quantity * invoice_items.unit_price) DESC"))
        .limit(1)
        .pluck(Arel.sql("DATE_TRUNC('day', invoices.created_at) AS created_at_day"))
        .first
        # .pluck("invoices.created_at as created_at_day").first
  end

  # def calculate_topitems_date(top_items)
  #   top_items.map do |item|
  #     top_selling_date = item.invoices
  #                            .joins(:transactions)
  #                            .where(transactions: { result: 'success' })
  #                            .group(:created_at)
  #                            .order(Arel.sql('COUNT(*) DESC, created_at DESC'))
  #                            .limit(1)
  #                            .pluck(:created_at)
  #                            .first


  #     formatted_date = top_selling_date.strftime("%Y-%m-%d")

  #     [item, formatted_date]
  #   end
  # end


  def calculate_topitems_date(top_items)
    top_items.map do |item|
      top_selling_date = item.invoices
                             .joins(:transactions)
                             .where(transactions: { result: 'success' })
                             .group(:created_at)
                             .order(Arel.sql('SUM(invoice_items.quantity * invoice_items.unit_price) DESC, created_at DESC'))
                             .limit(1)
                             .pluck(:created_at)
                             .first

      formatted_date = top_selling_date.strftime("%Y-%m-%d")

      [item, formatted_date]
    end
  end

end
