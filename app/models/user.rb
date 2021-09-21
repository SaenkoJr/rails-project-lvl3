# frozen_string_literal: true

class User < ApplicationRecord
  has_many :bulletins, inverse_of: :user, dependent: :destroy

  validates :email, presence: true, uniqueness: true, 'valid_email_2/email': true

  ransack_alias :name, :first_name_or_last_name

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def guest?
    false
  end
end
