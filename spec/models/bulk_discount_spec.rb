require 'rails_helper'

RSpec.describe BulkDiscount do 
  describe 'relationships' do 
    it {should belong_to :merchant }
    it {should have_many :discount_invoice_items}
    it {should have_many(:invoice_items).through(:discount_invoice_items)}
  end

  describe 'validations' do 
    it { should validate_numericality_of(:discount)}
    it { should validate_numericality_of(:quantity_threshold)}
  end
end