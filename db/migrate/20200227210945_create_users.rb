class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.integer :is_user, :limit => 1
      t.string :email
      t.integer :tel, :limit => 8
      t.text :token
      t.timestamp :time_token
      t.text :code
      t.timestamp :time_code
      t.belongs_to :personal_info

      t.timestamps null: false
    end
  end
end
