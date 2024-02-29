require 'rails_helper'

RSpec.describe 'Merchant Dashboard Show Page' do
  let!(:merchant_1) { Merchant.create!(name: "John Doe")}

  let!(:item1) { merchant_1.items.create!(name: "test", description: "im a good item", unit_price: 31211)}
  let!(:item2) { merchant_1.items.create!(name: "test2", description: "im a better item", unit_price: 41211, status: 1)}
  describe "merchant index" do
    it "shows specific merchant items" do
      visit merchant_items_path(merchant_id: merchant_1.id)

      expect(page).to have_content(item1.name)
      expect(page).to have_content(item2.name)

    end

    it "can enable or disable" do
      visit merchant_items_path(merchant_id: merchant_1.id)

      expect(page).to have_content(item1.name)

      expect(page).to have_content(item2.name)


      first(:button, "Enable").click

      # save_and_open_page
      expect(page).to have_button("Disable")


      expect(current_path).to eq(merchant_items_path(merchant_id: merchant_1.id))


    end

    it "separates disabled and enabled" do
      visit merchant_items_path(merchant_id: merchant_1.id)

      within("#disabled") do


        expect(page).to have_button("Enable")
      end
      within("#enabled") do


        expect(page).to have_button("Disable")
      end


    end

    it "can create a new item" do
      visit merchant_items_path(merchant_id: merchant_1.id)

      click_on ("Create Item")

      fill_in("name", with: "testitem")
      fill_in("description", with: "test is good")
      fill_in("unit_price", with: "22112")

      click_button("Submit")

      visit merchant_items_path(merchant_id: merchant_1.id)


      expect(current_path).to eq(merchant_items_path(merchant_id: merchant_1.id))
      expect(page).to have_content("testitem")

    end
  end

  describe '#calculate_top_items' do
    it 'returns the top 5 items by revenue' do
      merchant = create(:merchant)
      items = create_list(:item, 5, merchant: merchant)

      items.each do |item|
        invoice = create(:invoice)
        transaction = create(:transaction, invoice: invoice, result: 'success')
        create(:invoice_item, item: item, invoice: invoice, quantity: Random.rand(1..2), unit_price: 10)
      end

      top_items = create_list(:item, 5, merchant: merchant)

      top_items.each do |top_item|
        invoice = create(:invoice)
        transaction = create(:transaction, invoice: invoice, result: 'success')
        create(:invoice_item, item: top_item, invoice: invoice, quantity: Random.rand(3..9), unit_price: 10)
      end

      visit merchant_items_path(merchant_id: merchant.id)
      top_items.each do |top_item|
        total_revenue = top_item.invoice_items.sum { |invoice_item| invoice_item.quantity * invoice_item.unit_price }
        expect(page).to have_content("Total Revenue: $#{total_revenue}.00")
        expect(page).to have_link(top_item.name, href: merchant_item_path(merchant, top_item))
      end
    end

    it "shows the items with dates" do
      merchant = create(:merchant)
      items = create_list(:item, 5, merchant: merchant)
      dates = [Date.new(2023, 1, 5), Date.new(2023, 1, 4), Date.new(2023, 1, 3), Date.new(2023, 1, 2), Date.new(2023, 1, 1)] 

        items.each_with_index do |item, index|
          invoice = create(:invoice, created_at: dates[index])
          transaction = create(:transaction, invoice: invoice, result: 'success')
          create(:invoice_item, item: item, invoice: invoice, quantity: Random.rand(1..2), unit_price: 10)
        end
        top_items = merchant.calculate_top_items
        top_items_with_dates = merchant.calculate_topitems_date(top_items)

        visit merchant_items_path(merchant_id: merchant.id)

        expected_dates = ['2023-01-05', '2023-01-04', '2023-01-03', '2023-01-02', '2023-01-01']
         
        expected_dates.each do |date|
          expect(page).to have_content(date)
        end
    end
  end
end
