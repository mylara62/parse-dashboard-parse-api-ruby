class AddImagesToUser < ActiveRecord::Migration
  def change
  	 add_attachment :users, :imgQrCode
  	 add_attachment :users, :photo
  end
end
