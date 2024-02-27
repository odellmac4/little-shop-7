require 'rails_helper'

RSpec.describe 'Admin show page' do
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
end