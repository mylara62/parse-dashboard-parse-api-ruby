class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :profileName
      t.string :playerIdForPush
      t.string :coinsparkAddress
      t.string :bitcoinAddress
      t.string :bitcoinPassword
      t.string :phone
      t.string :email
      t.string :password

      t.timestamps null: false
    end
  end
end
