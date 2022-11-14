class BulkDiscount < ApplicationRecord
  belongs_to :merchant 
  has_many :invoice_items, through: :merchant 
  validates :discount, numericality: true  
  validates :quantity_threshold, numericality: true  


end