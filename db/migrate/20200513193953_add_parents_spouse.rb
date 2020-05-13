class AddParentsSpouse < ActiveRecord::Migration[6.0]
  def up
    change_table :users do |t|
      t.references :parent_1
      t.references :parent_2
      t.references :spouse
    end
  end

  def down
    change_table :relationship_types do |t|
      t.remove :parent_1
      t.remove :parent_2
      t.remove :spouse
    end
  end
end
