module AcceptanceSpecHelpers
  def expect_user_to_be_logged_in
    expect(page).to have_text 'Meine Daten'
  end
end

RSpec.configure do |config|
  config.include AcceptanceSpecHelpers, type: :feature
end
