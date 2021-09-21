# frozen_string_literal: true

class Bulletin < ApplicationRecord
  include AASM

  belongs_to :user, inverse_of: :bulletins
  belongs_to :category
  has_one_attached :photo

  validates :title, presence: true
  validates :category, presence: true
  validates :photo,
            size: { less_than_or_equal_to: 5.megabyte },
            content_type: %i[jpeg jpg png]

  ransack_alias :user, :user_first_name_or_user_last_name_or_user_email

  attribute :state_event, :string
  before_save :set_state

  aasm :state, column: :state do
    state :draft, initial: true
    state :on_moderate
    state :published
    state :rejected
    state :archived

    event :send_to_moderate do
      transitions from: %i[draft published on_moderate rejected], to: :on_moderate
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

  def set_state
    aasm(:state).fire(state_event) if state_event.present?
  end
end
