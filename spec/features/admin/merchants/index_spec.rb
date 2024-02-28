require 'rails_helper'

RSpec.describe 'Admin merchants index' do
    describe 'User story 24' do
        it 'shows the name of each merchant' do
            odell = Merchant.create!(name: "Odell")
            nico = Merchant.create!(name: "Nico")
            # As an admin,
            # When I visit the admin merchants index (/admin/merchants)
            visit admin_merchants_path
            # Then I see the name of each merchant in the system
            expect(page).to have_content("Nico")
            expect(page).to have_content("Odell")
        end
    end

    describe 'User story 25 part 1' do
        it 'links merchant name to show page' do
            odell = Merchant.create!(name: "Odell")
            nico = Merchant.create!(name: "Nico")
            
            # When I click on the name of a merchant from the admin merchants index page (/admin/merchants),
            visit admin_merchants_path

            expect(page).to have_link("Odell")
            expect(page).to have_link("Nico")
            # Then I am taken to that merchant's admin show page (/admin/merchants/:merchant_id)
            click_link "Odell"
            expect(current_path).to eq(admin_merchant_path(odell))    

            visit admin_merchants_path
            
            click_link "Nico"
            expect(current_path).to eq(admin_merchant_path(nico))
            # And I see the name of that merchant
        end
    end

    xdescribe 'User story 31' do
        it 'displays top 5 merchants by revenue with date for most merchant' do
            let!(:merchant1) { create(:merchant) }
            let!(:merchant2) { create(:merchant) }
            let!(:merchant3) { create(:merchant) }
            let!(:merchant4) { create(:merchant) }
            let!(:merchant5) { create(:merchant) }

            create(:invoice, merchant: merchant1, total: 100, created_at: 3.days.ago)
            create(:invoice, merchant: merchant1, total: 200, created_at: 2.days.ago)
            create(:invoice, merchant: merchant1, total: 300, created_at: 1.day.ago)
            create(:invoice, merchant: merchant2, total: 150, created_at: 2.days.ago)
            create(:invoice, merchant: merchant2, total: 250, created_at: 1.day.ago)
            create(:invoice, merchant: merchant3, total: 50, created_at: 1.day.ago)
            create(:invoice, merchant: merchant4, total: 20, created_at: 1.day.ago)
            create(:invoice, merchant: merchant5, total: 90, created_at: 1.day.ago)

            
            visit admin_merchants_path

            expect(page).to have_content("Top selling date")
            

        end
    end
end