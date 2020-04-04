class AddTypes < ActiveRecord::Migration[6.0]
  def up
    change_table :relationship_types do |t|
      t.text :female
      t.text :male
      t.text :prefix
    end
  end

  def down
    change_table :relationship_types do |t|
      t.remove :female
      t.remove :male
      t.remove :prefix
    end
  end
end
