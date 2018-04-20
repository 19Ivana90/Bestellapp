require 'rails_helper'

# FIXME more precise assertions pretty much across the board
RSpec.feature "Orders", js: true do
  include_context :user_is_logged_in

  before do
    # load seeds for products
    load Rails.root.join('spec/seeds/products.rb')
  end

  scenario "Creating an order and adding products to it" do
    visit orders_path

    click_on 'Neue Bestellung'
    fill_in 'order_customer_name', with: 'MPreis'
    select 'Österreich'
    click_on 'Anlegen'

    fill_in 'q', with: 'vegeta'
    click_on 'Suchen'

    quantity_selector = "order_line_items_attributes_%{index}_quantity"
    product_names = all('#products .product').map { |product| product.all('td')[1].text }
    fill_in quantity_selector % { index: 0 }, with: 10
    fill_in quantity_selector % { index: 2 }, with: 20
    click_on 'Produkte hinzufügen'

    expect(page).to have_text 'Kunde: MPreis'
    expect(page).to have_text 'Warenkorb erfolgreich geändert'
    expect(page).to have_text '10 x'
    expect(page).to have_text product_names[0]
    expect(page).to have_text '20 x'
    expect(page).to have_text product_names[2]
    expect(page).to_not have_text product_names[1]
  end

  scenario "Placing an order" do
    order = create(:order, user: current_user)
    create(:line_item, order: order)

    visit orders_path

    click_on order.id
    accept_confirm { click_on 'Abschließen' }

    expect(page).to have_text 'Bestellung erfolgreich abgeschlossen'
    expect(page).to have_text 'Bisher keine Bestellungen'

    click_on 'Erledigt'
    expect(page).to have_text order.customer_id
  end

  scenario "Adding products to an existing order" do
    order = create(:order, user: current_user)

    visit orders_path

    click_on order.id
    click_on 'Produkte hinzufügen'

    product_name = 'Podravka Ajvar 370 ml scharf'
    fill_in 'q', with: product_name
    click_on 'Suchen'

    fill_in 'order_line_items_attributes_0_quantity', with: 10
    click_on 'Produkte hinzufügen'

    expect(page).to have_text 'Warenkorb erfolgreich geändert'
    expect(page).to have_text '10 x'
    expect(page).to have_text product_name
  end

  scenario "Changing quantities" do
    order = create(:order, user: current_user)
    create(:line_item, order: order, quantity: 10)

    visit order_path(order)

    click_on 'Bearbeiten'
    fill_in 'order_line_items_attributes_0_quantity', with: 20
    click_on 'Speichern'

    expect(page).to have_text 'Warenkorb erfolgreich geändert'
    expect(page).to_not have_text '10 x'
    expect(page).to have_text '20 x'
  end

  scenario "Removing line items" do
    order = create(:order, user: current_user)
    create(:line_item, order: order)

    visit order_path(order)

    click_on 'Bearbeiten'
    check 'order_line_items_attributes_0__destroy'
    click_on 'Speichern'

    expect(page).to have_text 'Warenkorb erfolgreich geändert'
    expect(page).to have_text 'Diese Bestellung hat noch keine Produkte'
  end

  scenario "Not being able to add products to an order that aren't available in the order's country" do
    order = create(:order, user: current_user, country_code: 'DE')

    visit edit_order_path(order)

    fill_in 'q', with: 'vitaminka'
    click_on 'Suchen'

    expect(page).to have_text "Keine Produkte mit dem Suchbegriff „vitaminka“ gefunden."
    expect(page).to_not have_selector('.product')
  end

  scenario "Not being able to access other users' orders" do
    other_users_order = create(:order)

    visit orders_path
    expect(page).to_not have_text other_users_order.customer_name

    visit placed_orders_path
    expect(page).to_not have_text other_users_order.customer_name

    visit order_path(other_users_order)
    expect(page).to_not have_text other_users_order.customer_name

    visit edit_order_path(other_users_order)
    expect(page).to_not have_text 'Produkte hinzufügen'
  end
end
