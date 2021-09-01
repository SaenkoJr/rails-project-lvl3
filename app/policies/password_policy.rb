# frozen_string_literal: true

class PasswordPolicy < ApplicationPolicy
  def edit?
    !user.guest?
  end

  def update?
    !user.guest?
  end
end
