require 'rails_helper'

RSpec.describe 'Bulk Discounts Show Page' do
  before :each do
    let(:merchant) { FactoryBot.create(:merchant) }
    let(:item_1) { FactoryBot.create(:item, merchant: merchant) }
    let(:item_2) { FactoryBot.create(:item, merchant: merchant) }
    let(:item_3) { FactoryBot.create(:item, merchant: merchant) }

    
  end
end