class InvoiceItem < ApplicationRecord
  enum status: { packaged: 0, pending: 1, shipped: 2 }
  belongs_to :invoice 
  belongs_to :item 
  has_one :merchant, through: :item 
  # has_many :discount_invoice_items
  # has_many :bulk_discounts, through: :discount_invoice_items 
  has_many :bulk_discounts, through: :merchant
   
 def best_discount #finds best discount for invoice_item
   bulk_discounts.joins(:invoice_items)
   .where("invoice_items.quantity >= bulk_discounts.quantity_threshold")
   .order('bulk_discounts.discount desc').first
 end

end