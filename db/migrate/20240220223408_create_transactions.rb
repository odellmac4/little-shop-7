class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.string :credit_card_number
      t.string :credit_card_expiration_date
      t.string :result
      t.references :invoice, null: false, foreign_key: true

      t.timestamps
    end
  end
end
