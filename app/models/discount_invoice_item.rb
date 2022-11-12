class DiscountInvoiceItem < ApplicationRecord
  belongs_to :invoice_item 
  belongs_to :bulk_discount 
end