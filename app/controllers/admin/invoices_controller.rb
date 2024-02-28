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
        if @invoice.update(invoice_params)
            redirect_to admin_invoice_path(@invoice)
        end
    end

    private

    def invoice_params
        params.require(:invoice).permit(:status)
    end
end