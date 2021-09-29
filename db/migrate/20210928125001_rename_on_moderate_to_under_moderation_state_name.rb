class RenameOnModerateToUnderModerationStateName < ActiveRecord::Migration[6.1]
  def change
    Bulletin.where(state: :on_moderate).each do |b|
      b.state = :under_moderation
      b.save!
    end
  end
end
