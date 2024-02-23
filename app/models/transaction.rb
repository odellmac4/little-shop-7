class Transaction < ApplicationRecord
  belongs_to :invoice

  validates :credit_card_number, presence: true, length: { maximum: 16 }
  validates :credit_card_expiration_date, presence: true, format: { with: /\A\d{2}\/\d{2}\z/, message: "should be a MM/YY format"}
  validates :result, presence: true

  enum result: {
    success: "success",
    failed: "failed"
  }
end
