require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "relationships" do
    it { should belong_to(:customer) }
    it { should have_many(:transactions) }
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe "validations" do
    it { should validate_presence_of(:status) }
  end

  describe 'class methods' do
    describe '#incomplete_invoices' do
      let(:merchant) { FactoryBot.create(:merchant) }
      let(:item_1) { FactoryBot.create(:item, merchant: merchant) }
      let(:item_2) { FactoryBot.create(:item, merchant: merchant) }
      let(:item_3) { FactoryBot.create(:item, merchant: merchant) }
      let(:customer) { FactoryBot.create(:customer) }
      
      it 'returns array of invoice_items that have packaged or pending status' do
        invoice_1 = FactoryBot.create(:invoice, customer: customer)
        invoice_2 = FactoryBot.create(:invoice, customer: customer)
        invoice_3 = FactoryBot.create(:invoice, customer: customer)

        invoice_item_1 = InvoiceItem.create!(invoice: invoice_1, item: item_1, status: 0)
        invoice_item_2 = InvoiceItem.create!(invoice: invoice_2, item: item_2, status: 1)
        invoice_item_3 = InvoiceItem.create!(invoice: invoice_3, item: item_3, status: 2)

        expect(Invoice.incomplete_invoices).to eq([invoice_item_1, invoice_item_2])
      end

      it 'returns empty array if all statuses are shipped' do
        invoice_1 = FactoryBot.create(:invoice, customer: customer)
        invoice_2 = FactoryBot.create(:invoice, customer: customer)
        invoice_3 = FactoryBot.create(:invoice, customer: customer)

        invoice_item_1 = InvoiceItem.create!(invoice: invoice_1, item: item_1, status: 2)
        invoice_item_2 = InvoiceItem.create!(invoice: invoice_2, item: item_2, status: 2)
        invoice_item_3 = InvoiceItem.create!(invoice: invoice_3, item: item_3, status: 2)

        expect(Invoice.incomplete_invoices).to eq([])
      end
    end
  end


  describe 'instance methods' do
    describe '#total_revenue' do
      let(:merchant) { FactoryBot.create(:merchant) }
      let(:item_1) { FactoryBot.create(:item, merchant: merchant) }
      let(:item_2) { FactoryBot.create(:item, merchant: merchant) }
      let(:item_3) { FactoryBot.create(:item, merchant: merchant) }
      let(:customer) { FactoryBot.create(:customer) }

      it 'calculates total revenue for an invoice' do
        invoice_1 = FactoryBot.create(:invoice, customer: customer)
        invoice_2 = FactoryBot.create(:invoice, customer: customer)
        invoice_3 = FactoryBot.create(:invoice, customer: customer)

        invoice_item_1 = InvoiceItem.create!(invoice: invoice_1, quantity: 2, unit_price: 20, item: item_1, status: 0)
        invoice_item_2 = InvoiceItem.create!(invoice: invoice_1, quantity: 3, unit_price: 15, item: item_2, status: 1)
        invoice_item_3 = InvoiceItem.create!(invoice: invoice_1, quantity: 1, unit_price: 25, item: item_3, status: 2)

        invoice_item_4 = InvoiceItem.create!(invoice: invoice_2, quantity: 4, unit_price: 15, item: item_2, status: 0)
        invoice_item_5 = InvoiceItem.create!(invoice: invoice_2, quantity: 3, unit_price: 15, item: item_2, status: 1)
        invoice_item_6 = InvoiceItem.create!(invoice: invoice_2, quantity: 3, unit_price: 25, item: item_3, status: 2)

        expect(invoice_1.total_revenue).to eq(110)
        expect(invoice_2.total_revenue).to eq(180)
      end
    end
  end

  describe '#change_invoice_status' do
    let(:invoice) { FactoryBot.create(:invoice) }

      it 'can change an invoice status to in progress' do
        new_status_1 = 0
        new_status_2 = 1

        expect { invoice.update_status(new_status_1) }.to change { invoice.status }.to("in_progress")
        expect { invoice.update_status(new_status_2) }.to change { invoice.status }.to("cancelled")
      end
  end
end
