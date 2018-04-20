class OrderMailer < ApplicationMailer
  def orders_accepted(accepter_id, user_id, order_ids)
    @accepter = User.find(accepter_id)
    @user = User.find(user_id)
    @orders = @user.orders.find(order_ids)

    mail(to: @user.email, subject: "#{t(:x_orders, count: @orders.count)} angenommen")
  end
end
