class MerchantBulkDiscountsController < ApplicationController
    def index
        @merchant = Merchant.find(params[:id])
        @discounts = @merchant.discounts
    end
end