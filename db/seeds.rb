# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# From ChatGPT
# db/seeds.rb

# Create Merchants
Merchant.create!(name: "Merchant 1", status: 0)
Merchant.create!(name: "Merchant 2", status: 1)
Merchant.create!(name: "Merchant 3", status: 1)
Merchant.create!(name: "Merchant 4", status: 0)
Merchant.create!(name: "Merchant 5", status: 1)

# Create Bulk Discounts
BulkDiscount.create!(percentage_discount: 10, quantity_threshold: 50, merchant_id: 1)
BulkDiscount.create!(percentage_discount: 15, quantity_threshold: 100, merchant_id: 2)
BulkDiscount.create!(percentage_discount: 20, quantity_threshold: 75, merchant_id: 3)
BulkDiscount.create!(percentage_discount: 25, quantity_threshold: 60, merchant_id: 4)
BulkDiscount.create!(percentage_discount: 30, quantity_threshold: 80, merchant_id: 5)

# Create Bulk Discount Items (associations between bulk discounts and items)
BulkDiscountItem.create!(bulk_discount_id: 1, item_id: 1)
BulkDiscountItem.create!(bulk_discount_id: 2, item_id: 2)
BulkDiscountItem.create!(bulk_discount_id: 3, item_id: 3)
BulkDiscountItem.create!(bulk_discount_id: 4, item_id: 4)
BulkDiscountItem.create!(bulk_discount_id: 5, item_id: 5)

# Create Customers
Customer.create!(first_name: "John", last_name: "Doe")
Customer.create!(first_name: "Jane", last_name: "Smith")
Customer.create!(first_name: "Michael", last_name: "Johnson")
Customer.create!(first_name: "Emily", last_name: "Davis")
Customer.create!(first_name: "David", last_name: "Wilson")

# Create Invoices
Invoice.create!(customer_id: 1, status: 0)
Invoice.create!(customer_id: 2, status: 1)
Invoice.create!(customer_id: 3, status: 2)
Invoice.create!(customer_id: 4, status: 0)
Invoice.create!(customer_id: 5, status: 1)

# Create Invoice Items
InvoiceItem.create!(quantity: 1, unit_price: 100, item_id: 1, invoice_id: 1, status: 0)
InvoiceItem.create!(quantity: 2, unit_price: 200, item_id: 2, invoice_id: 2, status: 1)
InvoiceItem.create!(quantity: 3, unit_price: 300, item_id: 3, invoice_id: 3, status: 2)
InvoiceItem.create!(quantity: 4, unit_price: 400, item_id: 4, invoice_id: 4, status: 0)
InvoiceItem.create!(quantity: 5, unit_price: 500, item_id: 5, invoice_id: 5, status: 1)

# Create Items
Item.create!(name: "Item 1", description: "Description 1", unit_price: 100, merchant_id: 1, status: 0, has_discount: true)
Item.create!(name: "Item 2", description: "Description 2", unit_price: 200, merchant_id: 2, status: 1, has_discount: false)
Item.create!(name: "Item 3", description: "Description 3", unit_price: 300, merchant_id: 3, status: 2, has_discount: true)
Item.create!(name: "Item 4", description: "Description 4", unit_price: 400, merchant_id: 4, status: 0, has_discount: false)
Item.create!(name: "Item 5", description: "Description 5", unit_price: 500, merchant_id: 5, status: 1, has_discount: true)

# Create Transactions
Transaction.create!(credit_card_number: "1234567890123456", credit_card_expiration_date: "12/25", result: "success", invoice_id: 1)
Transaction.create!(credit_card_number: "2345678901234567", credit_card_expiration_date: "12/26", result: "failed", invoice_id: 2)
Transaction.create!(credit_card_number: "3456789012345678", credit_card_expiration_date: "12/27", result: "success", invoice_id: 3)
Transaction.create!(credit_card_number: "4567890123456789", credit_card_expiration_date: "12/28", result: "failed", invoice_id: 4)
Transaction.create!(credit_card_number: "5678901234567890", credit_card_expiration_date: "12/29", result: "success", invoice_id: 5)

