class StoreController < ApplicationController
  include CartsHelper
  skip_before_action :authorize
  before_action :set_cart
  def index
    @products = Product.order(:title)
    # The following is to get the number of visits to your homepage
    session[:counter] ||= 0
    @count = session[:counter] += 1
  end
end
