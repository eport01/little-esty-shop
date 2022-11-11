class BulkDiscount < ApplicationRecord
  belongs_to :merchant 
  has_many :discount_items
  has_many :items, through: :discount_items 
  validates :discount, numericality: true  
  validates :quantity_threshold, numericality: true  
end