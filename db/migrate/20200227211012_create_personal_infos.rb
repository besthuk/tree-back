class CreatePersonalInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :personal_infos do |t|
      t.string :firstname, :limit => 100
      t.string :secondname, :limit => 100
      t.string :lastname, :limit => 100
      t.integer :gender, :limit => 1
      t.integer :dob, :limit => 8
      t.text :photo
      t.text :country
      t.text :city
      t.text :address
      t.text :hobbies

      t.timestamps
    end
  end
end
