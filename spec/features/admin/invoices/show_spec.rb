require 'rails_helper'

RSpec.describe 'Admin invoice show page' do

    describe 'User story 33' do
        let(:customer_1) { FactoryBot.create(:customer) }
        let(:customer_2) { FactoryBot.create(:customer) }
        
        it 'displays invoice information' do

            invoice_1 = FactoryBot.create(:invoice, customer: customer_1, status: 0)
            invoice_2 = FactoryBot.create(:invoice, customer: customer_2, status: 1)
            invoice_3 = FactoryBot.create(:invoice, customer: customer_2, status: 2)

            # As an admin,
            # When I visit an admin invoice show page (/admin/invoices/:invoice_id)
            visit admin_invoice_path(invoice_1)
            # Then I see information related to that invoice including:
            # - Invoice id
            expect(page).to have_content("Invoice id: #{invoice_1.id}")
            # - Invoice status
            expect(page).to have_content("Invoice status: in_progress")
            # - Invoice created_at date in the format "Monday, July 18, 2019"
            expect(page).to have_content("Invoice created date: #{invoice_1.created_at.strftime("%A, %B %d, %Y")}")
            # - Customer first and last name
            expect(page).to have_content("Invoice customer name: #{invoice_1.customer.first_name} #{invoice_1.customer.last_name}")

            visit admin_invoice_path(invoice_3)
            expect(page).to have_content("Invoice id: #{invoice_3.id}")
            expect(page).to have_content("Invoice status: completed")
            expect(page).to_not have_content("Invoice status: cancelled")
            expect(page).to have_content("Invoice created date: #{invoice_3.created_at.strftime("%A, %B %d, %Y")}")
            expect(page).to have_content("Invoice customer name: #{invoice_3.customer.first_name} #{invoice_3.customer.last_name}")
        end 
    end

    describe 'User story 34' do
        let(:merchant) { FactoryBot.create(:merchant) }
        let(:item_1) { FactoryBot.create(:item, merchant: merchant) }
        let(:item_2) { FactoryBot.create(:item, merchant: merchant) }
        let(:item_3) { FactoryBot.create(:item, merchant: merchant) }
        let(:customer) { FactoryBot.create(:customer) }

        it 'displays invoice items and its attributes' do
            invoice_1 = FactoryBot.create(:invoice, customer: customer)
            invoice_2 = FactoryBot.create(:invoice, customer: customer)
            invoice_3 = FactoryBot.create(:invoice, customer: customer)

            invoice_item_1 = InvoiceItem.create!(invoice: invoice_1, quantity: 2, unit_price: 20, item: item_1, status: 0)
            invoice_item_2 = InvoiceItem.create!(invoice: invoice_1, quantity: 3, unit_price: 15, item: item_2, status: 1)
            invoice_item_3 = InvoiceItem.create!(invoice: invoice_1, quantity: 1, unit_price: 25, item: item_3, status: 2)

            invoice_item_4 = InvoiceItem.create!(invoice: invoice_2, quantity: 4, unit_price: 15, item: item_2, status: 0)
            invoice_item_5 = InvoiceItem.create!(invoice: invoice_2, quantity: 3, unit_price: 15, item: item_2, status: 1)
            invoice_item_6 = InvoiceItem.create!(invoice: invoice_2, quantity: 3, unit_price: 25, item: item_3, status: 2)
            
            invoice_item_7 = InvoiceItem.create!(invoice: invoice_3, quantity: 4, unit_price: 25, item: item_3, status: 0)
            invoice_item_8 = InvoiceItem.create!(invoice: invoice_3, quantity: 1, unit_price: 25, item: item_3, status: 1)

            # As an admin
            # When I visit an admin invoice show page (/admin/invoices/:invoice_id)
            visit admin_invoice_path(invoice_1)
            # Then I see all of the items on the invoice including:
            expect(page).to have_content("Invoice Items")

            within "#invoice_item-#{invoice_item_1.id}" do
                # - Item name
                expect(page).to have_content(item_1.name)
                # - The quantity of the item ordered
                expect(page).to have_content("Quantity: 2")
                # - The price the Item sold for
                expect(page).to have_content("Unit price: $20.00 ")
                # - The Invoice Item status
                expect(page).to have_content("Item Status: pending")
            end
            within "#invoice_item-#{invoice_item_2.id}" do
                expect(page).to have_content(item_2.name)
                expect(page).to have_content("Quantity: 3")
                expect(page).to have_content("Unit price: $15.00 ")
                expect(page).to have_content("Item Status: packaged")
            end
            within "#invoice_item-#{invoice_item_3.id}" do
                expect(page).to have_content(item_3.name)
                expect(page).to have_content("Quantity: 1")
                expect(page).to have_content("Unit price: $25.00 ")
                expect(page).to have_content("Item Status: shipped")
            end
            
            visit admin_invoice_path(invoice_3)

            within "#invoice_item-#{invoice_item_7.id}" do
                expect(page).to have_content(item_3.name)
                expect(page).to have_content("Quantity: 4")
                expect(page).to have_content("Unit price: $25.00 ")
                expect(page).to have_content("Item Status: pending")
            end
            
            within "#invoice_item-#{invoice_item_8.id}" do
                expect(page).to have_content(item_3.name)
                expect(page).to have_content("Quantity: 1")
                expect(page).to have_content("Unit price: $25.00 ")
                expect(page).to have_content("Item Status: packaged")
            end
        end
    end

    describe 'User story 35' do
        let(:merchant) { FactoryBot.create(:merchant) }
        let(:item_1) { FactoryBot.create(:item, merchant: merchant) }
        let(:item_2) { FactoryBot.create(:item, merchant: merchant) }
        let(:item_3) { FactoryBot.create(:item, merchant: merchant) }
        let(:customer) { FactoryBot.create(:customer) }
        
        it 'displays total revenue generated from an invoice' do
            invoice_1 = FactoryBot.create(:invoice, customer: customer)
            invoice_2 = FactoryBot.create(:invoice, customer: customer)
            invoice_3 = FactoryBot.create(:invoice, customer: customer)

            invoice_item_1 = InvoiceItem.create!(invoice: invoice_1, quantity: 2, unit_price: 20, item: item_1, status: 0)
            invoice_item_2 = InvoiceItem.create!(invoice: invoice_1, quantity: 3, unit_price: 15, item: item_2, status: 1)
            invoice_item_3 = InvoiceItem.create!(invoice: invoice_1, quantity: 1, unit_price: 25, item: item_3, status: 2)

            invoice_item_4 = InvoiceItem.create!(invoice: invoice_2, quantity: 4, unit_price: 15, item: item_2, status: 0)
            invoice_item_5 = InvoiceItem.create!(invoice: invoice_2, quantity: 3, unit_price: 15, item: item_2, status: 1)
            invoice_item_6 = InvoiceItem.create!(invoice: invoice_2, quantity: 3, unit_price: 25, item: item_3, status: 2)
            
            invoice_item_7 = InvoiceItem.create!(invoice: invoice_3, quantity: 4, unit_price: 25, item: item_3, status: 0)
            invoice_item_8 = InvoiceItem.create!(invoice: invoice_3, quantity: 1, unit_price: 25, item: item_3, status: 1)

            # As an admin
            # When I visit an admin invoice show page (/admin/invoices/:invoice_id)
            visit admin_invoice_path(invoice_1)
            # Then I see the total revenue that will be generated from this invoice.
            expect(page).to have_content("Total Revenue: $110.00")

            visit admin_invoice_path(invoice_2)
            expect(page).to have_content("Total Revenue: $180.00")
        end       
    end


    describe 'User story 36' do
        let(:merchant) { FactoryBot.create(:merchant) }
        let(:item_1) { FactoryBot.create(:item, merchant: merchant) }
        let(:item_2) { FactoryBot.create(:item, merchant: merchant) }
        let(:item_3) { FactoryBot.create(:item, merchant: merchant) }
        let(:customer) { FactoryBot.create(:customer) }
        it 'displays invoice status as a select field and can be updated by toggling the select field to chosen status' do
            invoice_1 = FactoryBot.create(:invoice, customer: customer)
            invoice_2 = FactoryBot.create(:invoice, customer: customer, status: 1)
            invoice_3 = FactoryBot.create(:invoice, customer: customer, status: 0)

            invoice_item_1 = InvoiceItem.create!(invoice: invoice_1, quantity: 2, unit_price: 20, item: item_1, status: 0)
            invoice_item_2 = InvoiceItem.create!(invoice: invoice_1, quantity: 3, unit_price: 15, item: item_2, status: 1)
            invoice_item_3 = InvoiceItem.create!(invoice: invoice_1, quantity: 1, unit_price: 25, item: item_3, status: 2)

            invoice_item_4 = InvoiceItem.create!(invoice: invoice_2, quantity: 4, unit_price: 15, item: item_2, status: 0)
            invoice_item_5 = InvoiceItem.create!(invoice: invoice_2, quantity: 3, unit_price: 15, item: item_2, status: 1)
            invoice_item_6 = InvoiceItem.create!(invoice: invoice_2, quantity: 3, unit_price: 25, item: item_3, status: 2)
            
            invoice_item_7 = InvoiceItem.create!(invoice: invoice_3, quantity: 4, unit_price: 25, item: item_3, status: 0)
            invoice_item_8 = InvoiceItem.create!(invoice: invoice_3, quantity: 1, unit_price: 25, item: item_3, status: 1)
            # As an admin     
            # When I visit an admin invoice show page (/admin/invoices/:invoice_id)
            visit admin_invoice_path(invoice_3)
            # I see the invoice status is a select field
            expect(page).to have_select("Status", options: ["In Progress", "Cancelled", "Completed"])
            # And I see that the invoice's current status is selected
            expect(page).to have_select("Status", selected: "In Progress")
            # When I click this select field,
            # Then I can select a new status for the Invoice,
            select "Cancelled", from: "invoice_status"
            # And next to the select field I see a button to "Update Invoice Status"
            # When I click this button
            click_on "Update Invoice Status"
            # I am taken back to the admin invoice show page
            expect(current_path).to eq(admin_invoice_path(invoice_3))
            # And I see that my Invoice's status has now been updated
            expect(page).to have_content("Cancelled")
        end
    end
end