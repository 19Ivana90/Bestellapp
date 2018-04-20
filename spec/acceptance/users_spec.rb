require 'rails_helper'

RSpec.feature "Users", js: true do
  scenario "User enters their data and confirms account" do
    user = create(:user, email: 'fist@chucknorris.com')
    token = ActionMailer::Base.deliveries.last.body.match(/token=(.+)/)[1]
    visit user_confirmation_path(confirmation_token: token)

    fill_in 'user[first_name]', with: 'Chuck'
    fill_in 'user[last_name]',  with: 'Norris'
    fill_in 'user[password]',   with: 'roundhousekick'

    find('.btn-primary').click

    expect_user_to_be_logged_in
  end

  scenario "User resets their password" do
    user = create(:user, :confirmed, email: 'fist@chucknorris.com')

    visit new_user_password_path

    fill_in 'user_email', :with => 'fist@chucknorris.com'

    find('.btn-primary').click

    token = ActionMailer::Base.deliveries.last.body.match(/token=(.+)/)[1]
    visit edit_user_password_path(reset_password_token: token)

    fill_in 'user[password]',              with: 'roundhousekick'
    fill_in 'user[password_confirmation]', with: 'roundhousekick'

    find('.btn-primary').click

    expect_user_to_be_logged_in
  end
end
