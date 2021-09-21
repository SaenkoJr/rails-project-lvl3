class RenameBulletinsColumns < ActiveRecord::Migration[6.1]
  def change
    change_table :bulletins do |t|
      t.rename :name, :title
      t.rename :status, :state
    end
  end
end
