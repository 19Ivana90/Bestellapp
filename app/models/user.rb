class User < ApplicationRecord
  include RoleManagement

  # Include default devise modules. Others available are:
  # :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  has_many :orders

  validates :last_name, presence: true

  scope :by_reverse_full_name, -> { order("last_name ASC, first_name ASC") }

  def admin?
    role == 'admin'
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def reverse_full_name
    "#{last_name}, #{first_name}".strip
  end

  def update_and_confirm(attributes)
    update(attributes) && confirm
  end

private

  def password_required?
    persisted? && (password.present? || password_confirmation.present?)
  end

end
