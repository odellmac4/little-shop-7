class MerchantBulkDiscountsController < ApplicationController
    def index
        @merchant = Merchant.find(params[:id])
        @discounts = @merchant.bulk_discounts
    end

    def show
        @merchant = Merchant.find(params[:merchant_id])
        @discount = @merchant.bulk_discounts.find(params[:id])
    end

    def new
        
    end
end