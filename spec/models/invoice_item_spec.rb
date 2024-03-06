RSpec.describe InvoiceItem, type: :model do
  describe "relationship" do
    it { should belong_to(:item) }
    it { should belong_to(:invoice) }
  end

  describe 'bulk discounts user story 6' do
    let(:merchant) { create(:merchant) }
    let(:item) { create(:item, merchant: merchant, unit_price: 10) }
    let(:bulk_discount) { create(:bulk_discount, merchant: merchant, quantity_threshold: 10, percentage_discount: 0.5) }
    let(:invoice_item) { create(:invoice_item, item: item, quantity: quantity) }

    before do
      merchant.bulk_discounts << bulk_discount  # Associate the bulk discount with the merchant
    end

    describe '#discounted_unit_price' do
      context 'shows a bulk discount when applicable' do
        let(:quantity) { 10 }

        it 'shows the discounted price when applicable' do
          expected_discounted_price = 10 * (1 - bulk_discount.percentage_discount).round(2)
          expect(invoice_item.discounted_unit_price).to eq(expected_discounted_price)
        end
      end

      context 'does not show a bulk discount when not applicable' do
        let(:quantity) { 5 }

        it 'shows the unit price when there is no discount' do
          expect(invoice_item.discounted_unit_price).to eq(item.unit_price)
        end
      end
    end
  end
end
