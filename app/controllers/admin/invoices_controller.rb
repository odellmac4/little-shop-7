class Admin::InvoicesController < ApplicationController
    include Admin::DashboardsHelper
    def index 
        @invoices = Invoice.all
    end

    def show
        @invoice = Invoice.find(params[:id])
    end

    def update
        @invoice = Invoice.find(params[:id])
        new_status = params[:invoice][:status]
        if @invoice.update_status(new_status)
            redirect_to admin_invoice_path(@invoice)
        end
    end
end