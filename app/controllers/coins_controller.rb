class CoinsController < ApplicationController
	before_action :parse_authenticate
	before_action :authenticate_user
	before_action :set_user
	before_action :set_coin,only: [:edit,:coin_update,:destroy,:show]
	before_action :coins_params,only: [:create,:coin_update]
	before_action :find_coin_details,only: [:new,:edit]

	include ParseParams

	def new;end

	def create;end

	def edit;end

	def show;end

	def coin_update;end

	def destroy
		begin
			@coin.parse_delete
			redirect_to dashboard_path
		rescue Parse::ParseProtocolError => e
		 	flash[:error] = "server execution time expired "
		 	redirect_to error_path
		rescue Parse::ConnectionError => e
		 	flash[:error] = "ConnectionError"
		 	redirect_to error_path
		end
	end	

	private

	def coins_params
		coin_type_params
		begin
	  	params[:action].eql?("create") ? 
	  	@coin = @parse_client.object("Coins") : @coin = @coin
	  	@coin_param = params[:coin]
	  	save_coin_params
			@coin.save
			redirect_to coin_path(@coin["objectId"])
	  rescue Parse::ParseProtocolError => e
		 	flash[:error] = "server execution time expired"
		 	redirect_to error_path
		rescue Parse::ConnectionError => e
		 	flash[:error] = "ConnectionError"
		 	redirect_to error_path
		end
  end

  def coin_type_params
  	coin_types = @parse_client.query("CoinTypes").tap do |coin_type|
      coin_type.eq("creatorID",session[:object_id])
      coin_type.eq("cointTypeName",params[:coin][:cointTypeName])
  	end.get.first
  	if coin_types
  		@coin_type = coin_types
  	else
	  	@coin_type = @parse_client.object("CoinTypes")
	  	@coin_type_params = params[:coin]
	  	save_coin_type_params
	  	@coin_type.save
  	end
  end 

	def set_coin
		begin
			coin = @parse_client.query("Coins")		
  		@coin = coin.eq("objectId", params[:id]).get.first
	  rescue Parse::ParseProtocolError => e
		 	flash[:error] = "server execution time expired "
		 	redirect_to error_path
		rescue Parse::ConnectionError => e
		 	flash[:error] = "ConnectionError"
		 	redirect_to error_path
		end
	end

	def find_coin_details
	begin
  	@coin_types = @parse_client.query("CoinTypes").tap do |coin|
      coin.eq("creatorID",session[:object_id])
  	end.get
  	@users = @parse_client.query("_User").tap do |user|
  		user.eq("role_name","User")
  	end.get
  	
  	@coin_types = @coin_types.collect{|coin_type| coin_type["objectId"]}
  rescue Parse::ParseProtocolError => e
	 	flash[:error] = "server execution time expired "
	 	redirect_to error_path
	rescue Parse::ConnectionError => e
	 	flash[:error] = "ConnectionError"
	 	redirect_to error_path
	end
	end

end

