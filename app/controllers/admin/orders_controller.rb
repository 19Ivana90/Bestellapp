class Admin::OrdersController < Admin::ApplicationController
  respond_to :html, :dta, only: [:accepted, :show]

  def self.dta_encoding
    'iso-8859-1'
  end

  def self.dta_mime_type
    "text/plain; charset=#{dta_encoding}"
  end

  def index
    @orders = Order.unaccepted.asc
  end

  def accepted
    @orders = Order.accepted.asc

    respond_to do |format|
      format.dta { send_data @orders.map(&:to_bueroware_dta).join("\n"), filename: 'bestellungen.dta', type: self.class.dta_mime_type }
      format.html { render }
    end
  end

  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.dta { send_data @order.to_bueroware_dta, filename: "bestellung-#{@order.number}.dta", type: self.class.dta_mime_type }
      format.html { render 'orders/show' }
    end
  end

  def accept
    accepted_orders = []
    unaccepted_orders = []

    params.fetch(:orders, {}).values.each do |attributes|
      order = Order.find(attributes[:id])

      if order.accept(attributes.slice(:customer_id))
        accepted_orders << order
      else
        unaccepted_orders << order
      end
    end

    if accepted_orders.any?
      accepted_orders.group_by(&:user_id).each do |user_id, orders|
        OrderMailer.orders_accepted(current_user.id, user_id, orders.map(&:id)).deliver_later
      end
    end

    notice = "#{t(:x_orders, count: accepted_orders.count)} erfolgreich angenommen"
    notice << ", #{t(:x_orders, count: unaccepted_orders.count)} nicht angenommen (Kundennummer leer)" if unaccepted_orders.any?
    redirect_to [:accepted, :admin, :orders], notice: "#{notice}."
  end
end
