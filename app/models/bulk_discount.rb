class BulkDiscount < ApplicationRecord
  belongs_to :merchant 
  # has_many :discount_invoice_items
  # has_many :items, through: :discount_invoice_items 
  # has_many :invoice_items, through: :discount_invoice_items
  has_many :invoice_items, through: :merchant 
  validates :discount, numericality: true  
  validates :quantity_threshold, numericality: true  


end