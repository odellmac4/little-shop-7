require 'rails_helper'

RSpec.describe 'Bulk Discounts Index Page' do
  let(:merchant) { FactoryBot.create(:merchant) }
  
  let!(:bulk_discount_1) { FactoryBot.create(:bulk_discount, merchant: merchant) }
  let!(:bulk_discount_2) { FactoryBot.create(:bulk_discount,  merchant: merchant) }
  let!(:bulk_discount_3) { FactoryBot.create(:bulk_discount,  merchant: merchant) }

  describe 'BD user story 1' do
    it 'displays all bulk discounts for merchant' do
      visit merchant_bulk_discounts_path(merchant)

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
      visit "/merchants/#{merchant.id}/bulk_discounts"

      expect(page).to have_link("Create a new discount", href: "/merchants/#{merchant.id}/bulk_discounts/new")
    end
  end

  describe 'user story 3' do
    it 'has a button to delete a discount' do
      visit "/merchants/#{merchant.id}/bulk_discounts"

      expect(page).to have_button('Delete Discount')
    end

    it 'can delete a discount and redirect to discount index page without deleted discount' do
      visit "/merchants/#{merchant.id}/bulk_discounts"

      find("#discount_#{bulk_discount_1.id} .delete-discount-button").click

      expect(page).to_not have_content(bulk_discount_1.percentage_discount)
      expect(page).to_not have_content(bulk_discount_1.quantity_threshold)
    end
  end
end