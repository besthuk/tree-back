class CreateRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :relationships, { id: false } do |t|
      t.references :user1, references: :users
      t.references :user2, references: :users
      t.references :type1, references: :relationship_types
      t.references :type2, references: :relationship_types
      t.timestamps
    end
  end
end
