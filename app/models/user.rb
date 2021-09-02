# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :bulletins, inverse_of: :author, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }, allow_nil: true

  ransack_alias :name, :first_name_or_last_name

  def full_name
    "#{first_name} #{last_name}"
  end

  def guest?
    false
  end
end
