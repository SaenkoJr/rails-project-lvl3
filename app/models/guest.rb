# frozen_string_literal: true

class Guest
  def self.policy_class
    UserPolicy
  end

  def id
    nil
  end

  def guest?
    true
  end

  def admin?
    false
  end

  def authenticate
    false
  end

  def full_name
    'Guest'
  end
end
