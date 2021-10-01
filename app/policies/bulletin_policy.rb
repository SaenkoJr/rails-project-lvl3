# frozen_string_literal: true

class BulletinPolicy < ApplicationPolicy
  def new?
    !user.guest?
  end

  def create?
    !user.guest?
  end

  def edit?
    author_or_admin? && !record.archive?
  end

  def update?
    author_or_admin?
  end

  def destroy?
    author_or_admin?
  end

  def archive?
    author_or_admin? && !record.archive?
  end

  private

  def author_or_admin?
    record.user_id == user&.id || user.admin?
  end
end
