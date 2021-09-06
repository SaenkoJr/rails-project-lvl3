# frozen_string_literal: true

class Bulletin < ApplicationRecord
  include AASM

  belongs_to :author, class_name: 'User', foreign_key: 'user_id', inverse_of: :bulletins
  belongs_to :category
  has_one_attached :photo

  validates :name, presence: true
  validates :category, presence: true
  validates :photo,
            size: { less_than_or_equal_to: 5.megabyte },
            content_type: %i[jpeg jpg png]

  ransack_alias :author, :author_first_name_or_author_last_name_or_author_email

  attribute :status_event, :string
  before_save :set_status

  aasm :status, column: :status do
    state :draft, initial: true
    state :on_moderate
    state :published
    state :rejected
    state :archived

    event :send_to_moderate do
      transitions from: %i[draft rejected], to: :on_moderate
    end

    event :publish do
      transitions from: :on_moderate, to: :published
    end

    event :reject do
      transitions from: :on_moderate, to: :rejected
    end

    event :hide do
      transitions from: %i[draft rejected], to: :draft
    end

    event :archive do
      transitions from: %i[draft on_moderate published rejected], to: :archived
    end
  end

  private

  def admin?
    current_user.admin?
  end

  def set_status
    aasm(:status).fire(status_event) if status_event.present?
  end
end
