include Warden::Test::Helpers
Warden.test_mode!

module QuickSignInHelpers
  def quick_sign_in(user = nil)
    user ||= User.last || create(:user, :confirmed)
    login_as(user, scope: :user)
  end

  def quick_sign_out
    logout(scope: :user)
  end
end

module SignInHelpers
  def sign_in(user = nil)
    @current_user = user || User.last || create(:user, :confirmed)

    visit root_path
    within('#user-login') do
      fill_in 'user_email',    with: @current_user.email
      fill_in 'user_password', with: '12345678'
      find('.btn.btn-primary').click
    end
  end

  def current_user
    @current_user
  end
end

RSpec.configure do |config|
  config.include(SignInHelpers, type: :feature)
  config.include(QuickSignInHelpers, type: :feature)

  config.after(:each) do
    Warden.test_reset!
  end
end
