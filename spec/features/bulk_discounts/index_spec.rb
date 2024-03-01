require 'rails_helper'

RSpec.describe 'Bulk Discounts Index Page' do
  let(:merchant) { FactoryBot.create(:merchant) }

  let!(:item1) { FactoryBot.create(:item, merchant: merchant) }
  let!(:item2) { FactoryBot.create(:item, merchant: merchant) }
  let!(:item3) { FactoryBot.create(:item, merchant: merchant) }
  
  let!(:bulk_discount_1) { FactoryBot.create(:bulk_discount, item: item1, merchant: merchant) }
  let!(:bulk_discount_2) { FactoryBot.create(:bulk_discount, item: item2, merchant: merchant) }
  let!(:bulk_discount_3) { FactoryBot.create(:bulk_discount, item: item3, merchant: merchant) }

  xdescribe 'BD user story 1' do
    it 'displays all bulk discounts for merchant' do
      visit merchant_bulk_discounts_path(merchant)
      save_and_open_page

      expect(page).to have_content(bulk_discount_1.percentage_discount)
      expect(page).to have_content(bulk_discount_2.quantity_threshold)
      expect(page).to have_content(bulk_discount_3.percentage_discount)
    end

    it 'shows the discount percentage' do
      visit merchant_bulk_discounts_path(merchant)

      expect(page).to have_content(bulk_discount_1.percentage_discount)      
      expect(page).to have_content(bulk_discount_2.percentage_discount)      
      expect(page).to have_content(bulk_discount_3.percentage_discount)
    end

    it 'shows quantity thresholds' do
      visit merchant_bulk_discounts_path(merchant)

      expect(page).to have_content(bulk_discount_1.quantity_threshold)
      expect(page).to have_content(bulk_discount_2.quantity_threshold)
      expect(page).to have_content(bulk_discount_3.quantity_threshold)
    end

    it 'has a link to each discounts show page' do
      visit merchant_bulk_discounts_path(merchant)

      expect(page).to have_link('View Discount', href: merchant_bulk_discount_path(merchant, bulk_discount_1))
      expect(page).to have_link('View Discount', href: merchant_bulk_discount_path(merchant, bulk_discount_2))
      expect(page).to have_link('View Discount', href: merchant_bulk_discount_path(merchant, bulk_discount_3))
    end
  end

  describe 'user story 2' do
    it 'has a link to create a new discount' do
      visit merchant_bulk_discount_path(merchant)

      expect(page).to have_link("Create a new discount", merchant_bulk_discounts_path(merchant, bulk_discount))
    end
  end
end