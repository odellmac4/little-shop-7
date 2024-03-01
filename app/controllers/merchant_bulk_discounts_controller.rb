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
        @merchant = Merchant.find(params[:merchant_id])
        @discount = Discount.new
    end

    def create
        @merchant = Merchant.find(params[:merchant_id])
        @discount = @merchant.discounts.create!(discount_params)
        redirect_to merchant_discounts_path(@merchant)
    end

    private

    def discount_params
        params.permit(:percent_discount, :quantity_threshold)
    end
end