require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "relationships" do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:bulk_discount_items) }
    it { should have_many(:bulk_discounts).through(:bulk_discount_items) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_numericality_of(:unit_price).is_greater_than(0).only_integer }
  end

  describe "#change_status" do
    let(:merchant) { FactoryBot.create(:merchant) }
    let(:item) { FactoryBot.create(:item, merchant: merchant) }

    it "changes the status to disable" do
      item.change_status('Disable')
      expect(item.status).to eq("Disable")
    end

    it "changes the status to enable" do
      item.change_status('Enable')
      expect(item.status).to eq("Enable")
    end
  end

  describe '#top_date' do
  it 'returns the top selling date for the item' do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)

   
    invoice1 = create(:invoice)
    create(:transaction, invoice: invoice1, result: 'success')
    create(:invoice_item, invoice: invoice1, quantity: 2, unit_price: 10)

    invoice2 = create(:invoice)
    create(:transaction, invoice: invoice2, result: 'success')
    create(:invoice_item, invoice: invoice2, quantity: 3, unit_price: 15)

    invoice3 = create(:invoice)
    create(:transaction, invoice: invoice3, result: 'failed')
    create(:invoice_item, invoice: invoice3, quantity: 4, unit_price: 20)

    a = InvoiceItem.create(item_id: item.id, invoice_id: invoice1.id)
    b = InvoiceItem.create(item_id: item.id, invoice_id: invoice2.id)
    c = InvoiceItem.create(item_id: item.id, invoice_id: invoice3.id)


    
    top_date = item.top_date

    
    expect(top_date).to eq(invoice2.created_at.strftime("%Y-%m-%d"))
  end
end
end
