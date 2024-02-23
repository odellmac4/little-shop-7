class ChangeStatusTypeInInvoices < ActiveRecord::Migration[7.1]
  def change
    remove_column :invoices, :status
    add_column :invoices, :status, :integer, null: false, default: 0
  end
end
