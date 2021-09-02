class AddStateToBulletin < ActiveRecord::Migration[6.1]
  def change
    add_column :bulletins, :status, :string
  end
end
