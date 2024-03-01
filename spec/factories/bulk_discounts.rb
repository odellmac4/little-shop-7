FactoryBot.define do
  factory :bulk_discount do
    percent_discount { 30 }
    quantity_threshold { 15 }
    merchant { nil }
  end
end
