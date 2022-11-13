class InvoiceItem < ApplicationRecord
  enum status: { packaged: 0, pending: 1, shipped: 2 }
  belongs_to :invoice 
  belongs_to :item 
  has_many :discount_invoice_items
  has_many :bulk_discounts, through: :discount_invoice_items 


end