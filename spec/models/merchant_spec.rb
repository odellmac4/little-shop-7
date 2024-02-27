require 'rails_helper'

RSpec.describe Merchant, type: :model do

  describe "relationships" do
    it { should have_many(:items) }
    it { should have_many(:invoices).through(:items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:customers) }
    it { should have_many(:invoice_items).through(:items) }
  end

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
      
      # Create 10 items for the merchant
      create_list(:item, 10, merchant: merchant)
      
      # Create invoices and invoice items with successful transactions
      merchant.items.each do |item|
        invoice = create(:invoice)
        create(:transaction, result: 'success', invoice: invoice)
        create(:invoice_item, item: item, invoice: invoice, quantity: 2, unit_price: 10)
      end
      
      top_items = merchant.calculate_top_items
      
      expect(top_items.length).to eq(5)
    end
  end

  describe '#merchant_best_day_by_revenue' do
    it 'returns the top selling date and merchant for each of the top 5 merchants by revenue' do
      # create 10 merchants
      merchants = create_list(:merchant, 10)

      # create 20 invoices with associated items for each merchant
      merchants.each do |merchant|
        20.times do
          invoice = create(:invoice)
          item = create(:item, merchant: merchant)
          create(:invoice_item, invoice: invoice, item: item)
        end
      end

      top_merchants = Merchant.merchant_best_day_by_revenue

      expect(top_merchants.length).to eq(5)

      # the - sign checks for sorting in descending order
      expected_order = top_merchants.sort_by { |merchant| -merchant.total_revenue }

      # check if the top merchants are in the expected order
      top_merchants.each_with_index do |merchant, index|
        expect(merchant).to eq(expected_order[index])
      end
    end
  end
end
