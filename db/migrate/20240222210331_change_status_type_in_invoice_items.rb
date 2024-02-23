class ChangeStatusTypeInInvoiceItems < ActiveRecord::Migration[7.1]
  def change
    remove_column :invoice_items, :status
    add_column :invoice_items, :status, :integer, null: false, default: 0
  end
end
