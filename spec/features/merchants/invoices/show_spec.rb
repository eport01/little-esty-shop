require 'rails_helper'

RSpec.describe "Merchant Invoice Show" do 
  before :each do 
    @merchant1 = Merchant.create!(name: "Kevin's Illegal goods")
    @merchant2 = Merchant.create!(name: "Denver PC parts")

    @customer1 = Customer.create!(first_name: "Sean", last_name: "Culliton")
    @customer2 = Customer.create!(first_name: "Sergio", last_name: "Azcona")
    @customer3 = Customer.create!(first_name: "Emily", last_name: "Port")

    @item1 = @merchant1.items.create!(name: "Funny Brick of Powder", description: "White Powder with Gasoline Smell", unit_price: 5000)
    @item2 = @merchant1.items.create!(name: "T-Rex", description: "Skull of a Dinosaur", unit_price: 100000)
    @item3 = @merchant2.items.create!(name: "UFO Board", description: "Out of this world MotherBoard", unit_price: 400)
    @item4 = @merchant2.items.create!(name: "Alarm Clock", description: "Wakes you up", unit_price: 400)

    @invoice1 = Invoice.create!(status: 1, customer_id: @customer2.id, created_at: "2022-11-01 11:00:00 UTC")
    @invoice2 = Invoice.create!(status: 1, customer_id: @customer1.id, created_at: "2022-11-01 11:00:00 UTC")
    @invoice3 = Invoice.create!(status: 1, customer_id: @customer3.id, created_at: "2022-11-01 11:00:00 UTC")
    
    @invoice_item1 = InvoiceItem.create!(quantity: 1, unit_price: 5000, status: 0, item_id: @item1.id, invoice_id: @invoice1.id)
    @invoice_item2 =InvoiceItem.create!(quantity: 2, unit_price: 5000, status: 1, item_id: @item2.id, invoice_id: @invoice1.id)
    @invoice_item3 = InvoiceItem.create!(quantity: 54, unit_price: 8000, status: 2, item_id: @item3.id, invoice_id: @invoice2.id)
    @invoice_item4 = InvoiceItem.create!(quantity: 10, unit_price: 2000, status: 2, item_id: @item3.id, invoice_id: @invoice3.id)
    @invoice_item5 = InvoiceItem.create!(quantity: 10, unit_price: 2000, status: 2, item_id: @item4.id, invoice_id: @invoice3.id)
    @invoice_item6 = InvoiceItem.create!(quantity: 1, unit_price: 100, status: 2, item_id: @item1.id, invoice_id: @invoice3.id)

    @discount1 = @merchant1.bulk_discounts.create!(discount: 0.20, quantity_threshold: 10)
    @discount2 = @merchant1.bulk_discounts.create!(discount: 0.10, quantity_threshold: 5)
    @discount3 = @merchant2.bulk_discounts.create!(discount: 0.15, quantity_threshold: 15)

  
    
    @invoice1.transactions.create!(result: 0)
    @invoice2.transactions.create!(result: 0)
    @invoice3.transactions.create!(result: 0)
  
  
  end

  describe 'US-15: Merchant Invoice Show Page'do 
    describe 'As a merchant, when I visit my invoice show page, I see info related to that invoice' do 
      it 'I see info of (invoice id, invoice status, invoice created_at date in format (Monday, July 18, 2019), & customer first and last name' do 

        visit merchant_invoice_path(@merchant1, @invoice1)
     
        expect(page).to have_content(@invoice1.id)
        expect(page).to have_content(@invoice1.status)
        expect(page).to have_content(@invoice1.created_at.strftime('%A, %B %d, %Y'))
        expect(page).to have_content(@invoice1.customer.first_name)
        expect(page).to have_content(@invoice1.customer.last_name)
        expect(page).to_not have_content(@invoice2.customer.first_name)
        expect(page).to_not have_content(@invoice2.customer.last_name)
        
      end
    end
  end

  describe 'US-16: Invoice Item Information ' do 
    describe 'As a merchant, when I visit my merchant invoice show page, I see all of my items on the invoice including:' do 
      it 'Displays item name, the quantity of the item ordered, price the item sold for, invoice item status, and i do not see any info related to items for other merchants' do 
       
        visit merchant_invoice_path(@merchant1, @invoice1)
        
        expect(page).to have_content(@item1.name)
        expect(page).to have_content(@item2.name)
        expect(page).to have_content(@invoice_item1.unit_price)
        expect(page).to have_content(@invoice_item2.unit_price)
        expect(page).to have_content(@invoice_item1.quantity)
        expect(page).to have_content(@invoice_item2.quantity)
        expect(page).to have_content(@invoice_item1.status)
        expect(page).to have_content(@invoice_item2.status)
        expect(page).to_not have_content(@item3.name)
        expect(page).to_not have_content(@invoice_item3.unit_price)
        expect(page).to_not have_content("Quantity: #{@invoice_item3.quantity}")

      end
    end
  end

  describe 'US-17: Total Revenue for invoice' do 
    it 'when I visit my merchant invoice show page, I see total revenue that will be generated from all items on the invoice' do 

      visit merchant_invoice_path(@merchant1, @invoice1)

      expect(page).to have_content("Total Revenue: 15000")
      expect(page).to_not have_content("Total Revenue: 432000")
    end
  end

  describe 'US-18: Update item status' do 
    describe 'I see that each invoice item status is a select field' do 
      it 'I see that the invoice items current status is selected' do 
        visit merchant_invoice_path(@merchant1, @invoice1)

        expect(page).to have_content(@invoice_item1.status)
        expect(@invoice_item1.status).to eq("packaged")
      end

      it 'when I click this select field, I can select a new status for the item
          and next to the select field I see a button to (Update Item Status)' do 
        visit merchant_invoice_path(@merchant1, @invoice1)

        expect(page).to have_button("Update Item Status")

      end

      it 'when I click the update item status button I am taken back to merchant invoice show page
          and status has been updated' do 
        visit merchant_invoice_path(@merchant1, @invoice1)
        within "#invoice_item_status-#{@invoice_item1.id}" do
        first(:radio_button, 'status').click 
          expect(page).to have_button("Update Item Status")
          click_button('Update Item Status')
          expect(current_path).to eq(merchant_invoice_path(@merchant1, @invoice1))
        end 
      end
    end
  end

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
      # @invoice_item5 = InvoiceItem.create!(quantity: 10, unit_price: 2000, status: 2, item_id: @item3.id, invoice_id: @invoice3.id)
  
  
      @discount1 = @merchant1.bulk_discounts.create!(discount: 0.20, quantity_threshold: 10)
      @discount2 = @merchant1.bulk_discounts.create!(discount: 0.10, quantity_threshold: 5)
      @discount3 = @merchant2.bulk_discounts.create!(discount: 0.15, quantity_threshold: 1)
    end 

    describe 'total revenue and discounted revenue' do 
      it 'i see total revenue and discounted revenue as separate' do 
        visit merchant_invoice_path(@merchant1, @invoice3)
        expect(page).to have_content("Total Revenue: 20000")
        expect(page).to have_content("Total Discounts: 3000")
        expect(page).to have_content("Total Revenue After Discounts: 17000")

      end

      it 'next to each invoice i see a link to show page for the bulk discount that was applied' do 
        visit merchant_invoice_path(@merchant1, @invoice3)
        within "#invoice_item-#{@invoice_item4.id}" do 
          expect(page).to have_content("Discount Applied: 15.0%")
          expect(page).to have_link("Discount Show Page for #{@item3.name}")
          expect(page).to_not have_link("Discount Show Page for #{@item4.name}")
          expect(page).to_not have_link("Discount Show Page for #{@item1.name}" )
          click_link "Discount Show Page for #{@item3.name}"

          expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @invoice_item4.best_discount))
        end

      end

      it 'after clicking button, user can go back to merchant dashboard' do 
        visit merchant_invoice_path(@merchant1, @invoice3)
        click_button "Back to #{@merchant1.name}'s Dashboard"
        expect(current_path).to eq("/merchants/#{@merchant1.id}/dashboard")
      end
    end
end
