require 'rails_helper'

RSpec.describe DiscountInvoiceItem do 
  describe 'relationships' do 
    it {should belong_to :invoice_item }
    it {should belong_to :bulk_discount }

  end
end