# frozen_string_literal: true

class GuestPolicy < ApplicationPolicy
  def show?
    false
  end

  def edit?
    false
  end

  def update?
    false
  end

  def destroy?
    false
  end
end
