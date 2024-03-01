require 'rails_helper'

RSpec.describe Merchant, type: :model do

  describe "relationships" do
    it { should have_many(:items) }
    it { should have_many(:invoices).through(:items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:customers) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:bulk_discounts) }
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
      items = create_list(:item, 5, merchant: merchant)

      items.each do |item|
        invoice = create(:invoice)
        transaction = create(:transaction, invoice: invoice, result: 'success')
        create(:invoice_item, item: item, invoice: invoice, quantity: Random.rand(1..2), unit_price: 10)
      end

      top_items = create_list(:item, 5, merchant: merchant)

      top_items.each do |top_item|
        invoice = create(:invoice)
        transaction = create(:transaction, invoice: invoice, result: 'success')
        create(:invoice_item, item: top_item, invoice: invoice, quantity: Random.rand(3..9), unit_price: 10)
      end

      expect(merchant.calculate_top_items).to match_array(top_items)
    end
  end

#   describe '#calculate_top_items_with_dates' do
#   let(:merchant) { create(:merchant) }
#   let!(:items) { create_list(:item, 5, merchant: merchant) }
#   let(:dates) { [Date.new(2023, 1, 5), Date.new(2023, 1, 4), Date.new(2023, 1, 3), Date.new(2023, 1, 2), Date.new(2023, 1, 1)] }

#   before do
#     items.each_with_index do |item, index|
#       invoice = create(:invoice, created_at: dates[index])
#       transaction = create(:transaction, invoice: invoice, result: 'success')
#       create(:invoice_item, item: item, invoice: invoice, quantity: Random.rand(1..2), unit_price: 10)
#     end
#   end

#   it 'returns the top dates for top items' do
#     top_items = merchant.calculate_top_items
#     top_items_with_dates = merchant.calculate_topitems_date(top_items)

#     expected_dates = ['2023-01-05', '2023-01-04', '2023-01-03', '2023-01-02', '2023-01-01']

#     top_items_with_dates.each do |(item, date)|
#       expect(expected_dates).to include(date)

#     end
#   end
# end


  describe "#total_revenue" do
    it "returns total revenue of a merchant" do
      merchant = create(:merchant)
      items = create_list(:item, 3, merchant: merchant)
      invoice_items = []
      items.each do |item|
        invoice = create(:invoice)
        transaction = create(:transaction, invoice: invoice, result: 'success')
        invoice_items << create(:invoice_item, item: item, invoice: invoice, quantity: 1, unit_price: 10)
      end
      expected = invoice_items.map{|invoice_item| invoice_item.quantity * invoice_item.unit_price}.sum

      expect(merchant.total_revenue).to eq(expected)
    end
  end

  describe "#self.top_merchants" do
    it "returns top 5 merchants by revenue" do
      top_merchants = create_list(:merchant, 5)
      top_merchants.each do |top_merchant|
        items = create_list(:item, 3, merchant: top_merchant)
        items.each do |item|
          invoice = create(:invoice)
          transaction = create(:transaction, invoice: invoice, result: 'success')
          invoice_items = create(:invoice_item, item: item, invoice: invoice, quantity: 3, unit_price: 10)
        end
      end

      merchants = create_list(:merchant, 5)
      merchants.each do |merchant|
        items = create_list(:item, 3, merchant: merchant)
        items.each do |item|
          invoice = create(:invoice)
          transaction = create(:transaction, invoice: invoice, result: 'success')
          invoice_items = create(:invoice_item, item: item, invoice: invoice, quantity: 1, unit_price: 10)
        end
      end

      expect(Merchant.top_merchants).to match_array(top_merchants)
    end
  end

  describe "#best_day" do
    it "returns the best day of a merchant" do
      merchant = create(:merchant)

      item = create(:item, merchant: merchant)
      # revenue for the best day should be 3 * (10 * 3) = 90
      # Note that we group by day and not full timestamp
      best_day = (Time.current - 6.day).beginning_of_day
      3.times do
        invoice = create(:invoice, created_at: best_day + Random.rand(0..23).hour)
        transaction = create(:transaction, invoice: invoice, result: 'success')
        invoice_items = create(:invoice_item, item: item, invoice: invoice, quantity: 3, unit_price: 10)
      end

      # revenue for the day should be 45
      day = (Time.current - 3.day).beginning_of_day
      3.times do
        invoice = create(:invoice, created_at: day)
        transaction = create(:transaction, invoice: invoice, result: 'success')
        invoice_items = create(:invoice_item, item: item, invoice: invoice, quantity: 1, unit_price: 15)
      end

      expect(merchant.best_day).to eq(best_day)
    end
  end
end
