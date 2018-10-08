class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:update, :destroy]
 
  def index
    @orders = current_user.orders
    @completed_count = (@orders.completed + @orders.paid).count
  end

  def show
  end

  def create
    if current_user.orders.create(order_params)
      flash[:success] = t 'main.order_success' 
      redirect_to orders_url
    else
      flash[:error] = t 'main.order_error'
      render 'new'
    end
  end

  def update
    respond_to do |format|
      if switch_state(params[:state])
        format.html { redirect_to orders_path }
        format.js
        format.json { render :show, status: :ok }
      else
        format.html { redirect_to orders_path }
        format.json { render :show, status: :unprocessable_entity}
      end
    end
  end

  def destroy
    @order.destroy if (@order.new? || @order.priced?)
    respond_to do |format|
      format.html { redirect_to orders_path }
      format.json { head :no_content }
    end
  end

  private

    def set_order
      @order = Order.find_by(id: params[:id])
    end

    def order_params
      params.permit(:caption, :description, :in_image_url)
    end

    def switch_state(target_state)
      case target_state
      when "accepted"
        return @order.accept_price!
      when "paid"
        customer = Stripe::Customer.create(
          email: params[:stripeEmail],
          source: params[:stripeToken]
        )

        charge = Stripe::Charge.create(
          customer: customer.id,
          amount: (@order.price * 100).round,
          description: "Customer #{current_user.email} paid for \"#{@order.caption}\"",
          currency: 'usd'
        )

        return @order.pay_for!
      when "canceled"
        return @order.cancel!
      else
        # unknown function
        return false;
      end

      rescue Stripe::CardError => e
        flash[:error] = e.message
        return false;
    end
end
