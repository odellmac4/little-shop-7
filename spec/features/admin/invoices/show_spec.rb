require 'rails_helper'

RSpec.describe 'Admin Invoices Show Page' do
    describe 'User Story 33' do
        before do
            @nico = Customer.create!(first_name: "Nico", last_name: "Shantii")
            @wolf = Customer.create!(first_name: "Wolf", last_name: "Goode")
            @invoice_1 = Invoice.create!(status: "Not Paid", customer_id: @nico.id)
            @invoice_2 = Invoice.create!(status: "Paid", customer_id: @wolf.id)
        end

        it 'shows invoice info - invoice id, status, invoice created_at date (Week-Day, Month dd, yyyy), customer first and last name' do
            # As an admin,
            # When I visit an admin invoice show page (/admin/invoices/:invoice_id)
            visit admin_invoice_path("#{@invoice_1.id}")
            # Then I see information related to that invoice including:
            # Invoice id
            expect(page).to have_content("Invoice ID: #{@invoice_1.id}")
            # Invoice status
            expect(page).to have_content("Status: #{@invoice_1.status}")
            # Invoice created_at date in the format "Monday, July 18, 2019"
            expect(page).to have_content("Created At: #{@invoice_1.formatted_created_at}")
            # Customer first and last name
            nico = Customer.find(@invoice_1.customer_id)
            expect(page).to have_content("Customer First Name: #{nico.first_name}")
            expect(page).to have_content("Customer Last Name: #{nico.last_name}")
            expect(page).to_not have_content("Wolf")
        end
    end
end
