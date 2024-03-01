require 'rails_helper'

RSpec.describe BulkDiscount do
    describe 'relationships' do
        it { should have_many(:bulk_discount_items) }
        it { should have_many(:items).through(:bulk_discount_items) }
        it { should belong_to(:merchant) }
    end

    describe 'validations' do
        it { should validate_presence_of :percent_discount}
        it { should validate_presence_of :quantity_threshold }
    end
end