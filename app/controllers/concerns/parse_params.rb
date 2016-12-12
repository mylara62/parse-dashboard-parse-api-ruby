module ParseParams
	include BooleanType
	include StringType

	def save_user_params
		@user = @parse_client.user({
			playerIdForPush: @user_params[:playerIdForPush],
			coinsparkAddress: @user_params[:coinsparkAddress],
			profileName: @user_params[:profileName],
			username: @user_params[:username],
			bitcoinAddress: @user_params[:bitcoinAddress],
			bitcoinPassword: @user_params[:bitcoinPassword],
			email: @user_params[:email],
			phone: @user_params[:phone],
			role_name: params[:role_type],
			password: @user_params[:password],
			imgQrCodeUrl: save_imgqrcode["url"],
			photoUrl: save_photo["url"]
		})
	end

	def save_trigger_params
		@trigger["period"] = params[:period]
  	@trigger["actionName"] = params[:actionName]
  	@trigger["expiryDate"] = params[:expiryDate]
  	@trigger["rewardCoinTypeName"] = params[:rewardCoinTypeName]
  	@trigger["coinTypeID"] = params[:coinTypeID]
  	@trigger["creatorID"] = params[:creatorID]
  	@trigger["groupName"] = params[:groupName]
  	@trigger["coinID"] = params[:coinID]
  	@trigger["rewardCoinTypeID"] = params[:rewardCoinTypeID]
  	@trigger["challengeStatus"] = params[:challengeStatus]
  	@trigger["coinTypeName"] = params[:coinTypeName]
  	@trigger["tags"] = params[:tags]
  	@trigger["amountCoinsReward"] = params[:amountCoinsReward]
  	@trigger["numberOfRepeat"] = params[:numberOfRepeat]
	end

	def save_coin_params
		@coin["coinTypeObjectID"] = @coin_type.id
  	@coin["cointTypeName"] = @coin_param[:cointTypeName]
		@coin["userID"] = @coin_param[:userID]
		@coin["creatorID"] = @coin_param[:creatorID]
		@coin["expiryDate"] = to_time_readable(@coin_param[:expiryDate])
		@coin["isPossibleTrade"] = to_bool(@coin_param[:isPossibleTrade])
		@coin["isCustomCoin"] = to_bool(@coin_param[:isCustomCoin])
		@coin["priceOneCoin"] = @coin_param[:priceOneCoin]
		@coin["imgQrCodeUrl"] =  save_coin_image["url"]
		@coin["totalAmountPoints"] = @coin_param[:totalAmountPoints]
	end

	def save_coin_type_params
		@coin_type["expiryDate"] = to_time_readable(@coin_type_params[:expiryDate])
		@coin_type["creatorID"] = @coin_type_params[:creatorID]
		@coin_type["cointTypeName"] = @coin_type_params[:cointTypeName]
		@coin_type["isCustomCoin"] = to_bool(@coin_type_params[:isCustomCoin])
		@coin_type["priceOneCoin"] = @coin_type_params[:priceOneCoin]
		@coin_type["totalAmountPoints"] = @coin_type_params[:totalAmountPoints]
	end

	def save_history_params
		@history["senderName"] = params[:senderName]
  	@history["tagName"] = params[:tagName]
  	@history["receiverAddress"] = params[:receiverAddress]
  	@history["coinTypeID"] = params[:coinTypeID]
  	@history["receiverID"] = params[:receiverID]
  	@history["commentString"] = params[:commentString]
  	@history["coinTypeName"] = params[:coinTypeName]
  	@history["amountReceived"] = params[:amountReceived]
  	@history["receiverName"] = params[:receiverName]
  	@history["senderUserID"] = params[:senderUserID]
  	@history["senderAddress"] = params[:senderAddress]
	end

	def save_tag_params
		@tag["TagName"] = params[:TagName]
	  @tag["coinTypeObjectID"] = params[:coinTypeObjectID]
		@tag["userID"] = params[:userID]
		@tag["creatorID"] = params[:creatorID]
		@tag["UserName"] = params[:username]
		@tag["totalAmountPoints"] = params[:totalAmountPoints]
	end

	def save_photo
		@parse_client.file({body: IO.read(@user_params[:photo].path),
												local_filename: @user_params[:photo].original_filename,
		  									content_type: "image/jpeg"}).save
	end

	def save_imgqrcode
			@parse_client.file({body: IO.read(@user_params[:imgQrCode].path),
													local_filename: @user_params[:imgQrCode].original_filename,
			  									content_type: "image/jpeg"}).save
	end
	
	def save_coin_image
  	@parse_client.file({body: IO.read(@coin_param[:imgQrCodeUrl].path),
												local_filename: @coin_param[:imgQrCodeUrl].original_filename,
												content_type: "image/jpeg"}).save
  end
  
end