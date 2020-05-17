class AddPhotoMessage < ActiveRecord::Migration[6.0]
  def up
    change_table :group_messages do |t|
      t.string :photo
    end
  end

  def down
    change_table :group_messages do |t|
      t.remove :photo
    end
  end
end
