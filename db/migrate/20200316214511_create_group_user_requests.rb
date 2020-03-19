class CreateGroupUserRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :group_user_requests do |t|
      t.belongs_to :user
      t.belongs_to :group
      t.belongs_to :owner, belong_to: :users
      t.integer :type_request
      t.integer :status
      t.string :description
      t.timestamps
    end
  end
end
