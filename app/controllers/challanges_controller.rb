class ChallangesController < ApplicationController
	before_action :parse_authenticate
	before_action :authenticate_user
	before_action :set_user
	before_action :set_trigger,only: [:edit,:trigger_update,:destroy,:show]
	before_action :trigger_params,only: [:trigger_create,:trigger_update]
	before_action :set_coin_details,only: [:new,:edit]

	include ParseParams

	def new;end

	def trigger_create;end

	def edit;end

	def show;end

	def trigger_update;end

	def destroy
		begin
			@trigger.parse_delete
			redirect_to dashboard_path
		rescue Parse::ParseProtocolError => e
		 	flash[:error] = "server execution time expired "
		 	redirect_to error_path
		rescue Parse::ConnectionError => e
		 	flash[:error] = "ConnectionError"
		 	redirect_to error_path
		end
	end

	def get_coin_type
		cointype = @parse_client.query("CoinTypes")	
		@cointype = cointype.eq("objectId", params[:coinTypeId]).get.first
		respond_to do |format|
			format.js
		end
	end

	private

	def trigger_params
		params[:action].eql?("trigger_create") ? 
		@trigger = @parse_client.object("Challenges") : @trigger = @trigger
		save_trigger_params
  	@trigger.save
  	redirect_to challange_path(@trigger["objectId"])
  end

  def set_coin_details
  	begin
	  	coins = @parse_client.query("Coins").tap do |coin|
	      coin.eq("creatorID",session[:object_id])
	  	end.get
	  	tags = @parse_client.query("HashTags").tap do |tag|
	      tag.eq("creatorID",session[:object_id])
	  	end.get

	  	hash_tags = tags.collect{|tag| tag["TagName"]}
	  	tag = hash_tags.find_all{|e| hash_tags.count(e) > 1} 
	  	tag.present? ? @tags = hash_tags.uniq! : @tags = hash_tags

	  	coin_types = @parse_client.query("CoinTypes").tap do |coin|
	      coin.eq("creatorID",session[:object_id])
	  	end.get

	  	@coin_types = coin_types.collect{|coin_type| coin_type["objectId"]}
	  	@coins = coins.collect{|coin| coin["objectId"]}
	  	@status_types = ["Complete","Incomplete"]
	  	@repeat_amounts = ["10","20","30","40","50","100","500","1000"]
	  rescue Parse::ParseProtocolError => e
		 	flash[:error] = "server execution time expired "
		 	redirect_to error_path
		rescue Parse::ConnectionError => e
		 	flash[:error] = "ConnectionError"
		 	redirect_to error_path
		end
  end

  def set_trigger
  	begin
  		trigger = @parse_client.query("Challenges")		
  		@trigger = trigger.eq("objectId", params[:id]).get.first
  	rescue Parse::ParseProtocolError => e
		 	flash[:error] = "server execution time expired "
		 	redirect_to error_path
		rescue Parse::ConnectionError => e
		 	flash[:error] = "ConnectionError"
		 	redirect_to error_path
		end
  end
end
