require 'rails_helper'

RSpec.describe BulkDiscount do
    it { should have_many(:bulk_discount_items) }
    it { should have_many(:items).through(:bulk_discount_items) }
    it { should belong_to(:merchant) }
end