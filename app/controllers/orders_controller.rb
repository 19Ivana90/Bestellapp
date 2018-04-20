class OrdersController < ApplicationController
  def index
    @orders = current_user.orders.open
  end

  def placed
    @orders = current_user.orders.placed

    render :index
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def new
    @order = current_user.orders.build
  end

  def create
    @order = current_user.orders.build(create_order_params)

    if @order.save
      redirect_to [:edit, @order], notice: 'Bestellung erfolgreich angelegt. Sie können nun Produkte zur Bestellung hinzufügen.'
    else
      flash.now[:alert] = 'Bestellung konnte nicht angelegt werden.'
      render :new
    end
  end

  def edit
    @order = current_user.orders.find(params[:id])

    @products = []
    @products = Product.search(params[:q], country_code: @order.country_code).by_name if params[:q].present?
  end

  def update
    @order = current_user.orders.find(params[:id])

    if @order.update(update_order_params)
      redirect_to @order, notice: 'Warenkorb erfolgreich geändert.'
    else
      flash.now[:alert] = 'Warenkorb konnte nicht geändert werden.'
      render :edit
    end
  end

  def place
    current_user.orders.find(params[:id]).place

    redirect_to [:orders], notice: 'Bestellung erfolgreich abgeschlossen.'
  end

  private

  def create_order_params
    params.fetch(:order, {}).permit(:customer_name, :customer_id, :country_code)
  end

  def update_order_params
    params.fetch(:order, {}).permit(line_items_attributes: [:id, :product_id, :quantity, :_destroy])
  end

end
