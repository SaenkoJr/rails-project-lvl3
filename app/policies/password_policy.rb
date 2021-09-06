# frozen_string_literal: true

class PasswordPolicy < ApplicationPolicy
  def edit?
    not_guest?
  end

  def update?
    not_guest?
  end

  private

  def not_guest?
    !user.guest?
  end
end
