require 'rails_helper'

RSpec.describe 'Bulk Discounts Update Page' do
  let(:merchant) { FactoryBot.create(:merchant) }

  let!(:bulk_discount_1) { FactoryBot.create(:bulk_discount, merchant: merchant) }

  xdescribe 'user story 5' do
    it 'has a form to edit the discount' do
    
    end

    it 'displays the current attributes of the discount pre-populated in the form' do

    end

    it 'can change the information about the discount and redirect to show page' do

    end
  end
end