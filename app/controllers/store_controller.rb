class StoreController < ApplicationController
  def index
    @products = Product.order(:title)
    # The following is to get the number of visits to your homepage
    session[:counter] ||= 0
    @count = session[:counter] += 1
  end
end
