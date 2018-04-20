require 'rails_helper'

RSpec.feature "Users (admin)", js: true do
  include_context :admin_is_logged_in

  before do
    visit users_path
  end

  scenario "Inviting a user" do
    click_on 'Neuer Benutzer'

    fill_in 'user_first_name', with: 'Chuck'
    fill_in 'user_last_name', with: 'Norris'
    fill_in 'user_email', with: 'fist@chucknorris.com'
    choose 'Standard'
    click_on 'Speichern'

    expect(page).to have_text 'Benutzer erfolgreich angelegt'
    mail = ActionMailer::Base.deliveries.last
    expect(mail.to).to eq ['fist@chucknorris.com']
    expect(mail.body).to include '/user/confirmation?confirmation_token='
  end
end
