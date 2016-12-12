class CreateCoins < ActiveRecord::Migration
  def change
    create_table :coins do |t|
      t.string :coinTypeObjectID
      t.string :cointTypeName
      t.string :userID
      t.string :creatorID
      t.date :expiryDate
      t.boolean :isPossibleTrade
      t.boolean :isCustomCoin
      t.string :priceOneCoin
      t.string :totalAmountPoints
      t.string :imgQrCodeUrl

      t.timestamps null: false
    end
  end
end
