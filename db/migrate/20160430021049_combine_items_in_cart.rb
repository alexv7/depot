class CombineItemsInCart < ActiveRecord::Migration
  def up
    # replace multiple items for a single product in a cart with a single item
    Cart.all.each do |cart|
      # count the number of each product in the cart (by first grouping them with their product_id and then summing up their quantity)
      sums = cart.line_items.group(:product_id).sum(:quantity)
      #note that sums is a hash with its keys as product_id and its values as quantity

      sums.each do |product_id, quantity|
        if quantity > 1
          # remove that individual line item object in your cart (based on product_id) in which the quantity is the sums hash is greater than 1
          cart.line_items.where(product_id: product_id).delete_all

          # replace with a new single line item object (based on product_id), with its quantity as the value from the sums hash
          item = cart.line_items.build(product_id: product_id)
          item.quantity = quantity
          item.save!
        end
      end
    end
  end

  def down
    # split items with quantity>1 into multiple items
    LineItem.where("quantity>1").each do |line_item|
      # add individual items
      line_item.quantity.times do
        LineItem.create cart_id: line_item.cart_id,
          product_id: line_item.product_id, quantity: 1
      end

      # remove original item
      line_item.destroy
    end
  end
end

=begin
• We start by iterating over each cart.
• For each cart, we get a sum of the quantity fields for each of the line items
associated with this cart, grouped by product_id. The resulting sums will
be a list of ordered pairs of product_ids and quantity.
• We iterate over these sums, extracting the product_id and quantity from each.
• In cases where the quantity is greater than one, we will delete all of the
individual line items associated with this cart and this product and replace
them with a single line item with the correct quantity.
=end
