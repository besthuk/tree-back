class AddRatio < ActiveRecord::Migration[6.0]
  def up
    change_table :relationship_types do |t|
      t.integer :ratio
    end
  end

  def down
    change_table :relationship_types do |t|
      t.remove :ratio
    end
  end
end
