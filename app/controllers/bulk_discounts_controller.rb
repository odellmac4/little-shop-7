class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.bulk_discounts
end

def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.bulk_discounts.find(params[:id])
end

def new
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.new
end

def create
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.bulk_discounts.create!(discount_params)
    redirect_to merchant_discounts_path(@merchant)
end

private

def discount_params
    params.permit(:percentage_discount, :quantity_threshold, :merchant_id)
end
end