require 'rails_helper'

RSpec.describe 'Merchant Invoice Show Page' do
  describe "As a merchant" do
    let(:merchant) { FactoryBot.create(:merchant) }

    let(:item_1) { FactoryBot.create(:item, merchant: merchant) }
    let(:item_2) { FactoryBot.create(:item, merchant: merchant) }
    let(:item_3) { FactoryBot.create(:item, merchant: merchant) }

    let(:customer) { FactoryBot.create(:customer) }

    let(:invoice) { FactoryBot.create(:invoice, customer: customer, created_at: Time.current) }

    let!(:invoice_item_1) { InvoiceItem.create!(invoice: invoice, quantity: 2, unit_price: 20, item: item_1, status: "packaged") }
    let!(:invoice_item_2) { InvoiceItem.create!(invoice: invoice, quantity: 1, unit_price: 10, item: item_2, status: "shipped") }
    let!(:invoice_item_3) { InvoiceItem.create!(invoice: invoice, quantity: 5, unit_price: 7, item: item_3, status: "pending") }

    describe "User Story 15" do
      it "shows information related to the invoice" do
        visit merchant_invoice_path(merchant, invoice)

        expect(page).to have_content(invoice.id)
        expect(page).to have_content(invoice.status)
        expect(page).to have_content(invoice.created_at.strftime("%A, %B %d, %Y"))
        expect(page).to have_content(customer.first_name)
        expect(page).to have_content(customer.last_name)
      end
    end

    describe "User Story 16" do
      it "shows all of the items on the invoice with the items' information" do
        visit merchant_invoice_path(merchant, invoice)

        expect(page).to have_content(item_1.name)
        expect(page).to have_content(invoice_item_1.quantity)
        expect(page).to have_content(invoice_item_1.unit_price)

        expect(page).to have_content(item_2.name)
        expect(page).to have_content(invoice_item_2.quantity)
        expect(page).to have_content(invoice_item_2.unit_price)

        expect(page).to have_content(item_3.name)
        expect(page).to have_content(invoice_item_3.quantity)
        expect(page).to have_content(invoice_item_3.unit_price)
      end
    end

    describe "User Story 17" do
      it "shows the total revenue of the invoice" do
        visit merchant_invoice_path(merchant, invoice)

        expect(page).to have_content("Total Revenue: 85")
      end
    end

    describe "User Story 18" do
      it "shows each invoice item's current status is a select field, when I click this select field I can select a new status for the Item, shows a button to 'Update Item Status' when I click this button I am taken back to the invoice show page and my Item's status has now been updated" do
        visit merchant_invoice_path(merchant, invoice)
        within "#item_#{invoice_item_1.item.id}" do
          expect(page).to have_select("invoice_item_status", selected: "Packaged")

          select "Shipped", from: "invoice_item_status"
          click_on "Update Item Status"
          expect(current_path).to eq(merchant_invoice_path(merchant, invoice))
          expect(page).to have_select("invoice_item_status", selected: "Shipped")
        end
        expect(page).to have_content("Item #{item_1.name} is updated successfully")
      end
    end

    describe 'bulk discounts user story 6' do
      it 'shows total discounted revenue' do
        visit merchant_invoice_path(merchant, invoice)

        expect(page).to have_content(whatever the content is)
      end
    end
  end
end
