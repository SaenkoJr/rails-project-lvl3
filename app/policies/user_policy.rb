# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def show?
    !user.guest?
  end

  def create?
    !user.guest?
  end

  def edit?
    !user.guest?
  end

  def update?
    !user.guest?
  end

  def destroy?
    !user.guest?
  end
end
