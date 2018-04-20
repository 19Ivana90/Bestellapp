module RoleManagement
  extend ActiveSupport::Concern

  ROLES = %w[user admin]

  included do
    validates :role, presence: true, inclusion: { in: ROLES, allow_blank: true }

    after_initialize :set_default_role
  end

  module ClassMethods
    def all_roles; ROLES; end
  end

  def set_default_role
    self.role ||= ROLES.first
  end
  private :set_default_role

end
