class DropDiscountInvoiceItemsTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :discount_invoice_items
  end
end
