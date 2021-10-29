# frozen_string_literal: true

class BulletinPolicy < ApplicationPolicy
  def create?
    !user.guest?
  end

  def update?
    author_or_admin? && !record.archived?
  end

  def destroy?
    author_or_admin?
  end

  def send_to_moderate?
    author? && record.may_send_to_moderate?
  end

  def archive?
    author_or_admin? && record.may_archive?
  end

  def publish?
    admin? && record.may_publish?
  end

  def reject?
    admin? && record.may_reject?
  end
end
