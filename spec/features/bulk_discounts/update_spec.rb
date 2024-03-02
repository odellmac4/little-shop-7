require 'rails_helper'

RSpec.describe 'Bulk Discounts Update Page' do
  let(:merchant) { FactoryBot.create(:merchant) }

  let!(:bulk_discount) { FactoryBot.create(:bulk_discount, merchant: merchant) }

  describe 'user story 5' do
    it 'has a form to edit the discount' do
      visit "/merchants/#{merchant.id}/bulk_discounts/#{bulk_discount.id}/edit"

      expect(page).to have_field('Percentage Discount', with: bulk_discount.percentage_discount)
      expect(page).to have_field('Quantity Threshold', with: bulk_discount.quantity_threshold)
    end

    it 'displays the current attributes of the discount pre-populated in the form' do
      visit "/merchants/#{merchant.id}/bulk_discounts/#{bulk_discount.id}/edit"

      expect(page).to have_field('Percentage Discount', with: bulk_discount.percentage_discount)
      expect(page).to have_field('Quantity Threshold', with: bulk_discount.quantity_threshold)
    end

    it 'can change the information about the discount and redirect to show page' do
      visit "/merchants/#{merchant.id}/bulk_discounts/#{bulk_discount.id}/edit"

      fill_in 'Percentage Discount', with: 50
      fill_in 'Quantity Threshold', with: 10
      click_on 'Update Discount'

      expect(page).to have_current_path("/merchants/#{merchant.id}/bulk_discounts/#{bulk_discount.id}")
      expect(page).to have_content("50")
      expect(page).to have_content("10")
    end
  end
end