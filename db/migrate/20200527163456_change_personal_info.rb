class ChangePersonalInfo < ActiveRecord::Migration[6.0]
  def change
    add_column :personal_infos, :dod, :integer,  :limit => 8
    add_column :personal_infos, :maidenname, :string, :limit => 100
  end
end
