FactoryBot.define do
  factory :invoice do
    status { "completed" }
    customer
  end

  factory :cancelled_invoice do
    status { "cancelled" }
    customer
  end
end
