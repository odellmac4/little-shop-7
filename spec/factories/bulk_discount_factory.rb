FactoryBot.define do
    factory :bulk_discount do
      percentage_discount { Faker::Number.between(from: 1, to: 100).to_f }
      quantity_threshold { Faker::Number.between(from: 1, to: 100) }
      merchant
    end
  end
  