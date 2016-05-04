class LineItemsController < ApplicationController
  include CartsHelper
  before_action :set_cart, only: [:create, :decrease, :increase]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_lineitem


  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
    @line_item = LineItem.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @line_item }
    end
    rescue ActiveRecord::RecordNotFound
    logger.error "Attempt to access invalid line_item #{ params[ :id ]}"
    redirect_to store_url, :notice => 'Invalid line item'
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # PUT /line_items/1
  # PUT /line_items/1.json
  def decrease
    #@cart = current_cart
    @line_item = @cart.decrease(params[:id])

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_path, notice: 'Line item was successfully updated.' }
        format.js   { @current_item = @line_item }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /line_items/1
  # PUT /line_items/1.json
  def increase
    #@cart = current_cart
    @line_item = @cart.increase(params[:id])

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_path, notice: 'Line item was successfully updated.' }
        format.js   { @current_item = @line_item }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end


  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product.id)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_url }
        format.js { @current_item = @line_item }
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    @line_item = LineItem.find(params[:id])
    # @line_item.quantity = params[:item][:quantity] #added this line here

    respond_to do |format|

      # if @line_item.update_attributes(params[:line_item])


      if @line_item.update(line_item_params)
        if (@line_item.quantity == nil || @line_item.quantity < 1)
          @line_item.destroy
        end
        format.html { redirect_to @line_item.cart, notice: 'Line item was successfully updated.' }
        format.js {@current_item = @line_item}
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.destroy
    respond_to do |format|
      format.html { redirect_to(@line_item.cart, notice: 'Line item was successfully destroyed.') }
      format.json { head :no_content }
    end
  end

  private

    def invalid_lineitem
      logger.error "Attempt to access invalid line item #{params[:id]}"
      redirect_to store_url, notice: 'Invalid line item'
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params
      params.require(:line_item).permit(:product_id, :quantity)
    end
end
