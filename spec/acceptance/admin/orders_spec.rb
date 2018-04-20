require 'rails_helper'

RSpec.feature "Orders (admin)", js: true do
  include_context :admin_is_logged_in

  scenario "Accepting orders" do
    order_1 = create(:order, :placed)
    order_2 = create(:order, :placed)
    order_3 = create(:order, :placed)
    order_4 = create(:order, :placed, user: order_2.user)

    visit admin_orders_path
    fill_in 'orders_0_customer_id', with: '1234-1234'
    fill_in 'orders_1_customer_id', with: '2345-2345'
    fill_in 'orders_3_customer_id', with: '4567-4567'
    click_on 'Bestellung(en) annehmen'

    expect(page).to have_text '3 Bestellungen erfolgreich angenommen, 1 Bestellung nicht angenommen (Kundennummer leer)'
    expect(page).to have_text order_1.customer_name
    expect(page).to have_text order_2.customer_name
    expect(page).to have_text order_4.customer_name
    expect(page).to_not have_text order_3.customer_name

    visit admin_orders_path
    expect(page).to_not have_text order_1.customer_name
    expect(page).to_not have_text order_2.customer_name
    expect(page).to_not have_text order_4.customer_name
    expect(page).to have_text order_3.customer_name

    [order_1, order_2, order_3, order_4].each(&:reload)

    mail_1 = ActionMailer::Base.deliveries[0]
    expect(mail_1.to).to eq [order_1.user.email]
    expect(mail_1.subject).to eq '1 Bestellung angenommen'
    expect(mail_1.body).to include "#{current_user.first_name} #{current_user.last_name} hat 1 Bestellung angenommen"
    expect(mail_1.body).to include "Bestellung #{order_1.number}: http://test.host/orders/#{order_1.to_param}"

    mail_1 = ActionMailer::Base.deliveries[1]
    expect(mail_1.to).to eq [order_2.user.email]
    expect(mail_1.subject).to eq '2 Bestellungen angenommen'
    expect(mail_1.body).to include "#{current_user.first_name} #{current_user.last_name} hat 2 Bestellungen angenommen"
    expect(mail_1.body).to include "Bestellung #{order_2.number}: http://test.host/orders/#{order_2.to_param}"
    expect(mail_1.body).to include "Bestellung #{order_4.number}: http://test.host/orders/#{order_4.to_param}"
  end
end
