# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def show?
    !user.guest? || admin?
  end

  def update?
    !user.guest? || admin?
  end

  def destroy?
    !user.guest? || admin?
  end
end
