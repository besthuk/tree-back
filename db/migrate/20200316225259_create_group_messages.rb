class CreateGroupMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :group_messages do |t|
      t.belongs_to :group
      t.text :message
      t.belongs_to :owner, belong_to: :user
      t.timestamps
    end
  end
end
