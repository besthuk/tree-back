class CreateGroupUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :group_users do |t|
      t.belongs_to :user
      t.belongs_to :group
      t.timestamps
    end
  end
end