class StoreController < ApplicationController
  include CartsHelper
  skip_before_action :authorize
  before_action :set_cart
  def index
    if params[:set_locale]
      redirect_to store_url(locale: params[:set_locale])
    else
    @products = Product.order(:title)
    end
    # The following is to get the number of visits to your homepage
    session[:counter] ||= 0
    @count = session[:counter] += 1
  end
end
