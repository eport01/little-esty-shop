class BulkDiscountsController < ApplicationController
  def index  
    @merchant = Merchant.find(params[:merchant_id])
    if params[:merchant_id]
      @merchant.bulk_discounts
    end
  end
end