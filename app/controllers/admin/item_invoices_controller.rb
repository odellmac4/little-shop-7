class Admin::ItemInvoicesController < ApplicationController
    def show
        invoice_item = InvoiceItem.find(params[:id])
    end
end