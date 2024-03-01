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
      visit new_merchant_bulk_discount_path(merchant.id)

      expect(page).to have_field('Discount Percent')
      expect(page).to have_field('Quantity Threshold')
      expect(page).to have_button('Create Discount')
    end

    it 'can create a new discount and redirect to the bulk discount index with the new discount added' do
      visit new_merchant_bulk_discount_path(merchant.id)

      fill_in 'Discount Percent', with: '50'
      fill_in 'Quantity Threshold', with: '25'
      click_on 'Create Discount'

      expect(page).to have_current_path("/merchants/#{merchant.id}/bulk_discounts")
      expect(page).to have_content("25")
      expect(page).to have_content("50")
    end
  end
end