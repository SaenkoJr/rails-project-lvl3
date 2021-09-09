# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def show?
    current_user? || admin?
  end

  def create?
    true
  end

  def edit?
    current_user? || admin?
  end

  def update?
    current_user? || admin?
  end

  def destroy?
    current_user? || admin?
  end

  private

  def current_user?
    record.id == user.id
  end

  def admin?
    user.admin?
  end
end
