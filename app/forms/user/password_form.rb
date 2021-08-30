# frozen_string_literal: true

class User::PasswordForm
  include ActiveModel::Model

  attr_accessor :old_password, :password, :password_confirmation

  validates :old_password, presence: true
  validates :password, presence: true, length: { minimum: 8 }
  validates :password_confirmation, presence: true
  validate :old_password_valid?
  validate :password_confirmation_match?

  def initialize(params = {}, user:)
    @user = user
    super(params)
  end

  def update
    return false if invalid?

    @user.password = password
    @user.password_confirmation = password_confirmation
    @user.save
  end

  private

  def old_password_valid?
    return if @user.authenticate(old_password)

    errors.add(:old_password, :incorrect)
  end

  def password_confirmation_match?
    return if password == password_confirmation

    errors.add(:password_confirmation, :does_not_match)
  end
end
