# frozen_string_literal: true

class PasswordPolicy < ApplicationPolicy
  def edit?
    owner_or_admin?
  end

  def update?
    owner_or_admin?
  end

  private

  def owner_or_admin?
    record.user_id == user&.id || user.admin?
  end
end
