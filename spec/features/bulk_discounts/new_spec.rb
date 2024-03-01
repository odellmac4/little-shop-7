require 'rails_helper'

RSpec.describe 'Bulk Discount New Page' do
  let(:merchant) { FactoryBot.create(:merchant) }

  let!(:item1) { FactoryBot.create(:item, merchant: merchant) }
  let!(:item2) { FactoryBot.create(:item, merchant: merchant) }
  let!(:item3) { FactoryBot.create(:item, merchant: merchant) }
  
  let!(:bulk_discount_1) { FactoryBot.create(:bulk_discount, merchant: merchant) }
  let!(:bulk_discount_2) { FactoryBot.create(:bulk_discount, merchant: merchant) }
  let!(:bulk_discount_3) { FactoryBot.create(:bulk_discount, merchant: merchant) }

  describe 'user story 2' do
    it 'has a form to create new discounts' do
      visit new_merchant_bulk_discount_path(merchant)


    end

    it 'requires [blahblahblah] data' do
      visit new_merchant_bulk_discount_path(merchant)

      expect(page).to have_content(bulk_discount_3.percentage_discount)
    end

    it 'can create a new discount' do
      visit new_merchant_bulk_discount_path(merchant)


    end

    it 'can redirect to the bulk discount index with the new discount added' do
      visit new_merchant_bulk_discount_path(merchant)


    end
  end
end