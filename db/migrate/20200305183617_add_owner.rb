class AddOwner < ActiveRecord::Migration[6.0]
  def up
    change_table :users do |t|
      t.references :owner, references: :users
      t.integer :is_reg, :limit => 1, default: 0
    end
  end

  def down
    change_table :users do |t|
      t.remove :owner_id
      t.remove :is_reg
    end
  end
end
