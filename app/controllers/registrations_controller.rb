class RegistrationsController < ::Devise::RegistrationsController
  def new
    render text: "Sie können sich nicht selbst registrieren. Bitte kontaktieren Sie einen Administrator des Systems, wenn Sie Zugang erhalten möchten.", status: :not_found
  end

  def create
    render text: "Sie können sich nicht selbst registrieren. Bitte kontaktieren Sie einen Administrator des Systems, wenn Sie Zugang erhalten möchten.", status: :not_found
  end

  def destroy
    render text: "Sie können Ihr Benutzerkonto nicht selbst löschen. Bitte kontaktieren Sie einen Administrator des Systems, wenn Sie Ihren Zugang deaktivieren möchten.", status: :not_found
  end

private

  def devise_parameter_sanitizer
    User::ParameterSanitizer.new(User, :user, params)
  end

end

class User::ParameterSanitizer < ::Devise::ParameterSanitizer
  def initialize(*)
    super

    permit(:sign_up, keys: name_keys)
    permit(:account_update, keys: name_keys)
  end

  def name_keys
    [:first_name, :last_name]
  end
end
