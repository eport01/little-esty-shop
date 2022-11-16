class BulkDiscount < ApplicationRecord
  belongs_to :merchant 
  has_many :invoice_items, through: :merchant 
  # validates :discount, numericality: true  
  validates :quantity_threshold, numericality: true  
  validates :discount, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1} 
end