RSpec.shared_context :user_is_logged_in do
  let!(:current_user) { create(:user, :confirmed) }

  background { quick_sign_in(current_user) }
end

RSpec.shared_context :admin_is_logged_in do
  include_context :user_is_logged_in

  background { current_user.update!(role: 'admin') }
end
