# frozen_string_literal: true

module ApplicationHelper
  include AuthConcern

  def author_or_admin?(record)
    record.user.id == current_user.id || current_user.admin?
  end
end
