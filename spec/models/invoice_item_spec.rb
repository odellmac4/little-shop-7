require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "relationship" do
    it { should belong_to(:item) }
    it { should belong_to(:invoice) }
  end

  describe 'bulk discounts user story 6' do
    let(:item) { create(:item) }
    let(:bulk_discount) { create(:bulk_discount, merchant: item.merchant, quantity_threshold: 10, percentage_discount: 0.5) }
    let(:invoice_item) { create(:invoice_item, item: item, quantity: quantity) }

    describe '#discounted_unit_price' do
      context 'shows a bulk discount when applicable' do
        let(:quantity) { 10 }

        it 'shows the discounted price when applicable' do
          expect(invoice_item.discounted_unit_price).to eq(item.unit_price * 0.5)
          expect(invoice_item.discounted_unit_price).to eq(2)
          end
      end

      context 'does not show a bulk discount when not applicable' do
        let(:quantity) { 5 }

        it 'shows the unit price when theres no discount' do
          expect(invoice_item.discounted_unit_price).to eq(item.unit_price)
        end
      end
    end
  end
end
