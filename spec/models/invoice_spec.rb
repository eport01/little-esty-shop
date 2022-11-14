require 'rails_helper' 

RSpec.describe Invoice do 
  before :each do 
    @merchant1 = Merchant.create!(name: "Kevin's Illegal goods")
    @merchant2 = Merchant.create!(name: "Denver PC parts")

    @customer1 = Customer.create!(first_name: "Sean", last_name: "Culliton")
    @customer2 = Customer.create!(first_name: "Sergio", last_name: "Azcona")
    @customer3 = Customer.create!(first_name: "Emily", last_name: "Port")

    @item1 = @merchant1.items.create!(name: "Funny Brick of Powder", description: "White Powder with Gasoline Smell", unit_price: 5000)
    @item2 = @merchant1.items.create!(name: "T-Rex", description: "Skull of a Dinosaur", unit_price: 100000)
    @item3 = @merchant2.items.create!(name: "UFO Board", description: "Out of this world MotherBoard", unit_price: 400)

    @invoice1 = Invoice.create!(status: 1, customer_id: @customer2.id, created_at: "2022-11-01 11:00:00 UTC")
    @invoice2 = Invoice.create!(status: 1, customer_id: @customer1.id, created_at: "2022-11-01 11:00:00 UTC")
    @invoice3 = Invoice.create!(status: 1, customer_id: @customer3.id, created_at: "2022-11-01 11:00:00 UTC")
    
    @invoice_item1 = InvoiceItem.create!(quantity: 1, unit_price: 5000, status: 0, item_id: @item1.id, invoice_id: @invoice1.id)
    @invoice_item2 =InvoiceItem.create!(quantity: 2, unit_price: 5000, status: 1, item_id: @item2.id, invoice_id: @invoice1.id)
    @invoice_item3 = InvoiceItem.create!(quantity: 10, unit_price: 2000, status: 2, item_id: @item3.id, invoice_id: @invoice2.id)
    @invoice_item4 = InvoiceItem.create!(quantity: 10, unit_price: 2000, status: 2, item_id: @item3.id, invoice_id: @invoice3.id)
    @invoice_item5 = InvoiceItem.create!(quantity: 10, unit_price: 2000, status: 2, item_id: @item3.id, invoice_id: @invoice3.id)


    @discount1 = @merchant1.bulk_discounts.create!(discount: 0.20, quantity_threshold: 10)
    @discount2 = @merchant1.bulk_discounts.create!(discount: 0.10, quantity_threshold: 5)
    @discount3 = @merchant2.bulk_discounts.create!(discount: 0.15, quantity_threshold: 1)


  end
  describe 'relationships' do
    it { should belong_to :customer }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many :transactions }

  end 

  describe "model methods"

  it 'find unshipped_items' do 
    expect(Invoice.unshipped_items).to eq([@invoice1, @invoice2, @invoice3])
  end

  it 'can calculate total revenue of an invoice' do 

    expect(@invoice1.total_revenue).to eq(15000.00) 
    expect(@invoice2.total_revenue).to eq(20000.00) 

  end

  it 'can calculate total discounted revenue of an invoice' do 
    expect(@invoice3.total_revenue).to eq(40000) 
    expect(@invoice2.total_revenue).to eq(20000.00) 
    expect(@invoice2.discount_revenue).to eq(3000) 
    expect(@invoice3.discount_revenue).to eq(6000)

    expect(@invoice2.after_discounts).to eq(17000) 
    expect(@invoice3.after_discounts).to eq(34000) 

  end
end