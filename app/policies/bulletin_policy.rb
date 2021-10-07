# frozen_string_literal: true

class BulletinPolicy < ApplicationPolicy
  def new?
    !user.guest?
  end

  def create?
    !user.guest?
  end

  def edit?
    author_or_admin? && !record.archived?
  end

  def update?
    author_or_admin? && !record.archived?
  end

  def destroy?
    author_or_admin?
  end

  def send_to_moderate?
    author? && !record.archived?
  end

  def archive?
    author_or_admin? && !record.archived?
  end

  def publish?
    admin?
  end

  def reject?
    admin?
  end
end
