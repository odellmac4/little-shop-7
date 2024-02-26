class Admin::MerchantsController < ApplicationController
    def index
        @merchants = Merchant.all
    end

    def show
        @merchant = Merchant.find(params[:id])
    end

    def edit
        @merchant = Merchant.find(params[:id])
    end

    def update
        merchant = Merchant.find(params[:id])
        if merchant.update(merchant_params)
            flash[:notice] = "Merchant information is updated successfully"
            redirect_to admin_merchant_path(merchant)
        end
    end

    private

    def merchant_params
        params.require(:merchant).permit(:name)
    end
end
