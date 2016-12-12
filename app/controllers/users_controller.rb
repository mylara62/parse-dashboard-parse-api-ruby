class UsersController < ApplicationController
	before_action :parse_authenticate
	before_action :authenticate_user,except: [:sign_up,:sign_in,:create_sign_up,:create_sign_in]
	before_action :set_user,except: [:sign_up,:sign_in,:create_sign_up,:create_sign_in]
	before_action :find_user,only: [:show,:destroy]
	before_action :user_params,only: [:create,:create_sign_up]
	before_action :set_roles,only: [:new,:sign_up]
	before_action :set_user_details,only: [:index]

	include ParseParams

	def new;end

	def create;end

	def show;end

	def sign_up;end

	def sign_in;end

	def sign_out
		session["object_id"] = nil
  	redirect_to sign_in_users_path
	end

	def create_sign_up;end

	def create_sign_in
		begin
		  user = Parse::User.authenticate(params[:username],params[:password], @parse_client)
		  session[:object_id] = user["objectId"]
	  	redirect_to dashboard_path
		rescue Parse::ParseProtocolError => e
		 	flash[:error] = "Invalid username or password"
		 	redirect_to :back
	  rescue Parse::ConnectionError => e
		 	flash[:error] = "ConnectionError"
		 	redirect_to :back
		end
	end
	
	def index;end

	def coin_rank
		if params[:coinType].blank?
  		set_coin_rank("ZBB")
  	else
  	@ranking_coins = set_coin_rank(params[:coinType])
	  	respond_to do |format|
		     format.js
		  end
  	end
	end

	private
	
	def user_params
		@user_params = params[:user]
		save_imgqrcode
		save_photo
		save_user_params
		@user.save
		redirect_to user_path(@user["objectId"])
	end

	def find_user
		begin
  		@user = @parse_client.query("_User").eq("objectId", params[:id]).get.first
  	rescue Parse::ConnectionError => e
	 		flash[:error] = "ConnectionError"
			redirect_to dashboard_path
	  rescue Parse::ParseProtocolError => e
		 	flash[:error] = "server execution time expired"
			redirect_to dashboard_path
		end
	end

	def set_roles
		@roles = ["Admin","Issuer","User"]
	end

	def set_user_details
		coins_users = @parse_client.query("Coins").tap do |q|
			q.eq("creatorID",session[:object_id])
		end.get.collect{|coin| coin["userID"]}
		coins_users.find_all{|e| coins_users.count(e) > 1}   
   	coins_users ? @coins_users = coins_users.uniq! : @coins_users = coins_users
		@coin_types = coin_type_details = @parse_client.query("CoinTypes").tap do |q|
      q.eq("creatorID",session[:object_id])
    end.get.collect{|coin_type| coin_type["cointTypeName"]}

    @ranking_coins = set_coin_rank(@coin_types.first) unless @coin_types.blank?
	end

	def set_coin_rank coin_type
		ranking_coins = @parse_client.query("Coins").tap do |coin|
	  	coin.eq("cointTypeName",coin_type) 
    end.get 
    ranking_amount = ranking_coins.map{|coin| [coin["userID"],coin["totalAmountPoints"]]}
		ranking_list = ranking_amount.collect{|id,amount| {userid: id,total_amount: amount.to_i}}
		ranking_list.sort_by{|hash| hash[:total_amount]}.reverse!
	end
end
