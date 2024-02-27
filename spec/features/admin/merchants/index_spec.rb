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

    describe 'User story 29' do
        it 'has a link to merchant create page' do
            # I see a link to create a new merchant
            odell = Merchant.create!(name: "Odell")
            nico = Merchant.create!(name: "Nico")

            visit '/admin/merchants'

            expect(page).to have_link('Create Merchant', href: '/admin/merchants/new')

            click_on 'Create Merchant'

            expect(current_path).to eq('/admin/merchants/new')
        end
    end

    # describe 'User story 27' do
    #     it 'has a button to enable/disable next to each merchant' do
    #         odell = Merchant.create!(name: "Odell")

    #         visit admin_merchants_path

    #         # 'Enable' initially appears because all merchants are disabled
    #         expect(page).to have_button("Enable")

    #         click_on "Enable"

    #         expect(page).to have_button("Disable")
    #         expect(odell.status).to eq 1
    #     end

    #     it 'changes merchant status and redirects to admin merch index' do
    #         odell = Merchant.create!(name: "Odell")

    #         visit admin_merchants_path

    #         click_on 'Enable'

    #         expect(current_path).to eq("/admin/merchants")
    #         expect(page).to have_button("Disable")
    #     end
    # end

    # describe 'User story 30' do
    #     it 'displays the top 5 merchants by revenue' do
    #         visit admin_merchants_path
    #     end

    #     it 'has links for each merchant name' do
    #         visit admin_merchants_path
    #     end
    # end

    describe 'User story 28' do
        it 'sorts merchants by disabled/enabled' do
            odell = Merchant.create!(name: "Odell", status: :enabled)
            nico = Merchant.create!(name: "Nico", status: :disabled)

            visit admin_merchants_path

            within ".disabled" do
                expect(page).to have_content("Nico")
            end

            within ".enabled" do
                expect(page).to have_content("Odell")
            end
        end
    end

    describe 'User story 31' do
        it 'displays top 5 merchants by best day by revenue' do
            
        end
    end
end