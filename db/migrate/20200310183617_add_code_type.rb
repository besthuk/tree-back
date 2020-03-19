class AddCodeType < ActiveRecord::Migration[6.0]
  def up
    change_table :users do |t|
      t.integer :code_type, after: 'code'
      t.string :new_value
    end
  end

  def down
    change_table :users do |t|
      t.remove :code_type
      t.remove :new_value
    end
  end
end
