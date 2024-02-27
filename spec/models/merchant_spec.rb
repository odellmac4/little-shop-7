require 'rails_helper'

RSpec.describe Merchant, type: :model do

  describe "relationships" do
    it { should have_many(:items) }
    it { should have_many(:invoices).through(:items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:customers) }
    it { should have_many(:invoice_items).through(:items) }
  end

#   describe "validations" do
#     it { should validate_presence_of(:name) }
#   end

  describe "#top_customers" do
    let(:merchant) { FactoryBot.create(:merchant) }
    let(:item) { FactoryBot.create(:item, merchant: merchant) }
    let(:top_customers) { FactoryBot.create_list(:customer, 5) }
    let(:customers) { FactoryBot.create_list(:customer, 5) }

    before do
      top_customers.each do |customer|
        invoice = FactoryBot.create(:invoice, customer: customer)
        invoice.items = [item]
        FactoryBot.create_list(:transaction, Random.rand(2..5), invoice: invoice)
        invoice.save!
      end
      customers.each do |customer|
        invoice = FactoryBot.create(:invoice, customer: customer)
        invoice.items = [item]
        FactoryBot.create_list(:transaction, 1, invoice: invoice)
        invoice.save!
      end
    end
    it "returns the top 5 customers with their success transactions counts in descending order" do
      expect(merchant.top_customers).to match_array(top_customers)
    end
  end

  describe "#items_ready_to_ship" do
    let(:merchant) { FactoryBot.create(:merchant) }
    let(:item_1) { FactoryBot.create(:item, merchant: merchant) }
    let(:item_2) { FactoryBot.create(:item, merchant: merchant) }
    let(:item_3) { FactoryBot.create(:item, merchant: merchant) }
    let(:customer) { FactoryBot.create(:customer) }

    it "returns the array of invoice_items that do not have status 'shipped' and in ascending order of invoice created_at" do
      invoice_1 = FactoryBot.create(:invoice, customer: customer)
      invoice_2 = FactoryBot.create(:invoice, customer: customer)
      invoice_3 = FactoryBot.create(:invoice, customer: customer)

      invoice_item_1 = InvoiceItem.create!(invoice: invoice_1, item: item_1, status: "pending")
      invoice_item_2 = InvoiceItem.create!(invoice: invoice_2, item: item_2, status: "packaged")
      invoice_item_3 = InvoiceItem.create!(invoice: invoice_3, item: item_3, status: "shipped")

      expect(merchant.items_ready_to_ship).to eq([invoice_item_2])
    end
  end

  describe '#calculate_top_items' do
    it 'returns the top 5 items by revenue' do
      merchant = create(:merchant) 

      
      items = create_list(:item, 10, merchant: merchant) 
      items.each do |item|
        invoice = create(:invoice)
        transaction = create(:transaction, invoice: invoice, result: 'success')
        create(:invoice_item, item: item, invoice: invoice, quantity: 2, unit_price: 10)
      end
      
      top_items = merchant.calculate_top_items
      
      expect(top_items.length).to eq(5)
      expect(top_items.first).to be_a(Item)
      expect(top_items.first.total_revenue).to be >= top_items.last.total_revenue 
      
    end
  end

  describe "#merchant_best_day_by_revenue" do
  it "displays top selling date and merchant for each of the top 5 merchants by revenue" do
    # Define factories
  FactoryBot.define do
    factory :merchant do
      name { Faker::Company.name }
    end

    factory :item do
      name { Faker::Commerce.product_name }
      description { Faker::Lorem.sentence }
      unit_price { Faker::Number.decimal(l_digits: 2) }
      merchant
    end

    factory :invoice do
      customer
      created_at { Faker::Date.backward(days: 30) } # Random date in the past 30 days
    end

    factory :invoice_item do
      item
      invoice
      quantity { Faker::Number.between(from: 1, to: 10) }
      unit_price { Faker::Number.decimal(l_digits: 2) }
    end
  end

  describe '.merchant_best_day_by_revenue' do
    it 'returns the best day by revenue for the top 5 merchants' do
      # define factories
      FactoryBot.define do
        factory :merchant do
          name { Faker::Company.name }
        end
    
        factory :item do
          name { Faker::Commerce.product_name }
          description { Faker::Lorem.sentence }
          unit_price { Faker::Number.decimal(l_digits: 2) }
          merchant
        end
    
        factory :invoice do
          customer
          created_at { Faker::Date.backward(days: 30) } # random date in the past 30 days
        end
    
        factory :invoice_item do
          item
          invoice
          quantity { Faker::Number.between(from: 1, to: 10) }
          unit_price { Faker::Number.decimal(l_digits: 2) }
        end
      end
    
      # create 10 merchants
      merchants = create_list(:merchant, 10)
    
      # create invoices for each merchant and put items with them
      merchants.each do |merchant|
        items = create_list(:item, 25, merchant: merchant)
        invoices = create_list(:invoice, 15, customer: create(:customer))
    
        invoices.each do |invoice|
          items.each do |item|
            create(:invoice_item, invoice: invoice, item: item)
          end
        end
      end
    
      # calculate the total revenue for each merchant
      merchant_revenues = {}
      merchants.each do |merchant|
        # sum the revenue generated from all invoices associated with the merchant
        total_revenue = merchant.invoices.sum { |invoice| invoice.invoice_items.sum { |item| item.quantity * item.unit_price } }
        merchant_revenues[merchant] = total_revenue
      end
    
      # select the top 5 merchants by revenue
      top_merchants = merchant_revenues.sort_by { |_merchant, revenue| -revenue }.first(5).to_h.keys
    
      # calculate the best day by revenue for each of the top 5 merchants
      best_days = top_merchants.map do |merchant|
        merchant.merchant_best_day_by_revenue
      end
          
      expect(best_days.length).to eq(5)
    end
end
