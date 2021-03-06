class ProductsController < ApplicationController
  include CartsHelper
  before_action :set_cart
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_product


  # GET /products
  # GET /products.json
  # def index
  #   @products = Product.all
  # end

  def index
    @products = Product.where(locale: I18n.locale)
    respond_to do |format|
       format.html # index.html.erb
       format.json { render json: @products }
     end
  end

  def who_bought
    @product = Product.find(params[:id])
    @latest_order = @product.orders.order(:updated_at).last
    if stale?(@latest_order) #see caching with rails, or google rails stale? etag...its about caching info and updating them as they come
      respond_to do |format|
        format.html
        format.xml { render :xml => @product.to_xml(:include => :orders) }
        format.json {render :json => @product.to_json(:include => :orders)}
        format.atom
      end
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @product }
    end
    rescue ActiveRecord::RecordNotFound
    logger.error "Attempt to access product #{ params[ :id ]}"
    redirect_to products_url, :notice => 'Invalid product'
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def invalid_product
      logger.error "Attempt to access invalid product #{params[:id]}"
      OrderNotifier.product_error_occured.deliver
      redirect_to store_url, notice: 'Invalid product'
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:title, :description, :image_url, :price, :locale)
    end
end
