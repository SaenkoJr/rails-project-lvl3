# frozen_string_literal: true

module ApplicationHelper
  include AuthConcern

  def author_or_admin?(record)
    record.user.id == current_user.id || current_user.admin?
  end

  def show_full_name_or_email(user)
    user.full_name.empty? ? user.email : user.full_name
  end
end
