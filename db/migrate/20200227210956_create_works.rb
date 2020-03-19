class CreateWorks < ActiveRecord::Migration[6.0]
  def change
    create_table :works do |t|
      t.text :name
      t.belongs_to :user
      t.timestamps
    end
  end
end
