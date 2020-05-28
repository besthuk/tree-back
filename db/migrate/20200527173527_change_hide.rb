class ChangeHide < ActiveRecord::Migration[6.0]
  def change
    add_column :group_user_requests, :hide, :integer, default: 0
    add_column :group_messages, :hide, :integer, default: 0
  end
end
