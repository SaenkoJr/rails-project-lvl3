# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def show?
    owner_or_admin?
  end

  def create?
    true
  end

  def edit?
    owner_or_admin?
  end

  def update?
    owner_or_admin?
  end

  def destroy?
    user.admin?
  end

  private

  def owner_or_admin?
    record.user_id == user&.id || user.admin?
  end
end
