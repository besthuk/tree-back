class CreateGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.string :description
      t.string :photo
      t.belongs_to :owner, belong_to: :users
      t.timestamps
    end
  end
end
