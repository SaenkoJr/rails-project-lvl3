# frozen_string_literal: true

class PasswordPolicy < ApplicationPolicy
  def edit?
    non_guest_or_admin?
  end

  def update?
    non_guest_or_admin?
  end

  private

  def non_guest_or_admin?
    !user.guest? || user.admin?
  end
end
