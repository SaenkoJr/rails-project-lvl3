# frozen_string_literal: true

class Guest
  def guest?
    true
  end

  def admin?
    false
  end

  def authenticate
    false
  end
end
