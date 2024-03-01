require 'rails_helper'

RSpec.describe 'Bulk Discounts Show Page' do
  let(:merchant) { FactoryBot.create(:merchant) }

  let!(:item1) { FactoryBot.create(:item, merchant: merchant) }
  let!(:item2) { FactoryBot.create(:item, merchant: merchant) }
  let!(:item3) { FactoryBot.create(:item, merchant: merchant) }
  
  let!(:bulk_discount_1) { FactoryBot.create(:bulk_discount, merchant: merchant) }
  let!(:bulk_discount_2) { FactoryBot.create(:bulk_discount, merchant: merchant) }
  let!(:bulk_discount_3) { FactoryBot.create(:bulk_discount, merchant: merchant) }

  # BD US 2
  it 'shows quantity threshold and percentage discount for the discount' do
    visit "/merchants/#{merchant.id}/bulk_discounts/#{bulk_discount_1.id}"

    expect(page).to have_content(bulk_discount_1.quantity_threshold)
    expect(page).to have_content(bulk_discount_1.percentage_discount)
    expect(page).to_not have_content(bulk_discount_2.percentage_discount)
    expect(page).to_not have_content(bulk_discount_3.percentage_discount)
  end

  describe 'user story 5' do
    it 'has a link to edit the discount' do
      visit "/merchants/#{merchant.id}/bulk_discounts/#{bulk_discount_1.id}"
      
      expect(page).to have_link('Edit Discount', href: "/merchants/#{merchant.id}/bulk_discounts/#{bulk_discount_1.id}/edit")
    end
  end
end