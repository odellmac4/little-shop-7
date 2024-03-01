require 'rails_helper'

RSpec.describe 'Merchants Dashboard Show Page' do
  describe "As a merchant" do
    describe "User Story 1-2-3" do
      let(:merchant) { FactoryBot.create(:merchant) }
      let(:item) { FactoryBot.create(:item, merchant: merchant) }
      let(:top_customers) { FactoryBot.create_list(:customer, 5) }
      let(:customers) { FactoryBot.create_list(:customer, 5) }

      before do
        top_customers.each do |customer|
          invoice = FactoryBot.create(:invoice, customer: customer)
          invoice.items = [item]
          FactoryBot.create_list(:transaction, Random.rand(2..5), invoice: invoice)
          invoice.save!
        end
        customers.each do |customer|
          invoice = FactoryBot.create(:invoice, customer: customer)
          invoice.items = [item]
          FactoryBot.create_list(:transaction, 1, invoice: invoice)
          invoice.save!
        end
      end

      it "shows the name of my merchant" do
        visit merchant_dashboard_path(merchant)

        expect(page).to have_content(merchant.name)
      end

      it "shows link to my merchant item index and merchant invoices index" do
        visit merchant_dashboard_path(merchant)

        expect(page).to have_link("My Items", href: merchant_items_path(merchant))
        expect(page).to have_link("My Invoices", href: merchant_invoices_path(merchant))
      end

      it "shows the names of the top 5 customers and the number of successful transactions with my merchant" do
        visit merchant_dashboard_path(merchant)

        top_customers.each do |top_customer|
          expect(page).to have_content("#{top_customer.first_name} #{top_customer.last_name} #{top_customer.transactions.count}")
        end
      end

      # BD US 1
      xit 'shows a link to all a merchants bulk discounts' do
        visit merchant_dashboard_path(merchant)

        expect(page).to have_content("View all bulk discounts")
        expect(page).to have_link("View all bulk discounts", href: merchant_bulk_discounts_path(@merchant))
      end
    end

    describe "User Story 4-5" do
      let(:merchant) { FactoryBot.create(:merchant) }
      let(:item_1) { FactoryBot.create(:item, merchant: merchant) }
      let(:item_2) { FactoryBot.create(:item, merchant: merchant) }
      let(:item_3) { FactoryBot.create(:item, merchant: merchant) }
      let(:customer) { FactoryBot.create(:customer) }

      let(:invoice_1) { FactoryBot.create(:invoice, customer: customer, created_at: Time.current - 3.day) }
      let(:invoice_2) { FactoryBot.create(:invoice, customer: customer, created_at: Time.current - 2.day) }
      let(:invoice_3) { FactoryBot.create(:invoice, customer: customer, created_at: Time.current - 5.day) }

      let!(:invoice_item_1) { InvoiceItem.create!(invoice: invoice_1, item: item_1, status: "packaged") }
      let!(:invoice_item_2) { InvoiceItem.create!(invoice: invoice_2, item: item_2, status: "packaged") }
      let!(:invoice_item_3) { InvoiceItem.create!(invoice: invoice_3, item: item_3, status: "shipped") }

      it "shows a section for items ready to ship with its invoice id that link to merchant's invoice show page" do
        visit merchant_dashboard_path(merchant)

        expect(page).to have_content("#{invoice_item_1.item.name}")
        expect(page).to have_link(invoice_item_1.invoice_id, href: merchant_invoice_path(merchant, invoice_1))
        expect(page).to have_content("#{invoice_item_2.item.name}")
        expect(page).to have_link(invoice_item_2.invoice_id, href: merchant_invoice_path(merchant, invoice_2))
      end

      it "shows the date that the invoice was created in this format 'Monday, July 18, 2019', and in ordered from oldest to newest" do
        visit merchant_dashboard_path(merchant)

        expect(page).to have_content("#{invoice_item_1.invoice.created_at.strftime("%A, %B %d, %Y")}")
        expect(page).to have_content("#{invoice_item_2.invoice.created_at.strftime("%A, %B %d, %Y")}")
        expect("#{invoice_item_1.invoice.created_at.strftime("%A, %B %d, %Y")}").to appear_before("#{invoice_item_2.invoice.created_at.strftime("%A, %B %d, %Y")}")
      end
    end
  end
end
