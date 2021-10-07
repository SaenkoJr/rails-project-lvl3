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

  aasm :state, column: :state do
    state :draft, initial: true
    state :under_moderation
    state :published
    state :rejected
    state :archived

    event :send_to_moderate do
      transitions from: %i[draft under_moderation published rejected], to: :under_moderation
    end

    event :publish do
      transitions from: :under_moderation, to: :published
    end

    event :reject do
      transitions from: :under_moderation, to: :rejected
    end

    event :make_draft do
      transitions from: %i[draft published rejected], to: :draft
    end

    event :archive do
      transitions from: %i[draft under_moderation published rejected], to: :archived
    end
  end
end
