module ApplicationHelper
	def rank_user userId
		user = @parse_client.query("_User").eq("objectId", userId).get.first
		user["username"] unless user.nil?
	end
	def find_user userId
		user = @parse_client.query("_User").eq("objectId", userId).get.first
		user["coinsparkAddress"] unless user.nil?
	end
	def get_user userId
		@coin_user = @parse_client.query("_User").eq("objectId", userId).get.first
	end
	def find_coin_type cointypeId
		coin = @parse_client.query("CoinTypes").eq("objectId", cointypeId).get.first
		image_tag coin["logoCoinType"].url,style: "width:60%" rescue nil unless coin.nil?
	end
	def find_transaction_history cointype
		@histories = @parse_client.query("SendHistory").tap do |q|
			q.eq("coinTypeName",cointype)
			q.limit = 50
		end.get
	end
	def set_tag cointypeId
		coin_type = @parse_client.query("CoinTypes").eq("objectId", cointypeId).get.first
		coin_type["cointTypeName"]
	end
	def get_user_coin_type coin_type
		@parse_client.query("CoinTypes").tap do|q|
			q.eq("cointTypeName",coin_type)
		end.get.count
	end
end
