class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:set_price, :destroy]
 
  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.where("customer = " + current_user.id.to_s)
  end

  def show
  end

  # POST /orders
  # POST /orders.json
  def create
    if !process_func(params[:func])
      @order = Order.new(order_params)
      if @order.save
        flash[:success] = "Order successfully created"
        redirect_to orders_url
      else
        flash[:error] = "Something went wrong"
        render 'new'
      end
    end
  end

  # DELETE /orders/:id
  # DELETE /orders/:id.json
  def destroy
    if (!@order.paid?)
      @order.destroy
    end
    respond_to do |format|
      format.html { redirect_to orders_path }
      # format.js {}
      format.json { head :no_content }
    end
  end

  private

    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.permit(:caption, :description, :in_image_url)
    end

    def process_func(func_name)
      if (func_name == nil)
        return false;
      end
      @order = Order.find(params[:order_id])
      respond_to do |format|
        result = false;
        case func_name
        when "set_price"
          result = @order.set_price!
        when "accept_price"
          result = @order.accept_price!
        when "complete_work"
          result = @order.mark_as_completed!
        when "pay"
          result = @order.pay_for!
        when "reject"
          result = @order.reject_work!
        else
          # unknown function
          return false;
        end

        if result
          format.html { redirect_to orders_url}
          format.js {}
          format.json {}
        else
          flash[:error] = "Something went wrong"
          render 'new'
        end
      end
      return true;
    end
end
