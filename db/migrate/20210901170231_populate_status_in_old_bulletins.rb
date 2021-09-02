class PopulateStatusInOldBulletins < ActiveRecord::Migration[6.1]
  def change
    Bulletin.find_each do |b|
      b.status = 'draft'
      b.save!
    end
  end
end
