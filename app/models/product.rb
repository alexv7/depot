class Product < ActiveRecord::Base
  has_many :line_items
  has_many :orders, through: :line_items #this is because both Order and Product have many line_items, so this is how you associate a Product with Order 

  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, :description, :image_url, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)\Z}i,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }
  # we used the allow_blank option to avoid getting multiple error messages (cant be blank, and format be must be gif, jpg, png)

  def self.latest
    Product.order(:updated_at).last
  end

  private
  #ensure that there are no line items referencing this product
  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:message, 'Line Items present')
      return false
    end
  end


end
