class Order < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  PAYMENT_TYPES = [ "Check", "Credit card", "Purchase order" ]
  validates :name, :address, :email, presence: true
  validates :pay_type, inclusion: PAYMENT_TYPES

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
    item.cart_id = nil
    line_items << item
    end
  end
end


# Some folks might be wondering why we bother to validate the payment type,
# given that its value comes from a drop-down list that contains only valid
# values. We do it because an application can’t assume that it’s being fed values
# from the forms it creates. Nothing is stopping a malicious user from submitting
# form data directly to the application, bypassing our form. If the user set an
# unknown payment type, they might conceivably get our products for free.
