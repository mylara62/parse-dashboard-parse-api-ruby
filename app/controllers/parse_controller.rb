class ParseController < ApplicationController
	before_action :parse_authenticate
	before_action :set_coin,only: [:edit_coin,:update_coin]
	before_action :authenticate_user,except: [:index]
  before_action :set_user
  
	def index;end

  def api_doc;end
	
	def dashboard
		begin
			set_details
			set_graph(@coin_types.first) unless @coin_types.nil?
		rescue Parse::ParseProtocolError => e
		 	flash[:error] = "server execution time expired "
		rescue Parse::ConnectionError => e
		 	flash[:error] = "ConnectionError"
		end
	end

	def get_graph
		if params[:coinType].blank?
			set_graph("Seven")
	  else
	  	graph_trigger = @parse_client.query("Challenges").tap do |q|
	        q.eq("creatorID",session[:object_id])
					q.eq("coinTypeName",params[:coinType])
			end.get
			@graph_triggers = graph_trigger.collect{|trigger| {date: (trigger["createdAt"]).to_time.strftime("%d"),
	                                                       amount: trigger["amountCoinsReward"]}}
			 respond_to do |format|
	     		format.js
	   	 end
	  end
  end

  private

  def set_details
    @coins = @parse_client.query("Coins").tap do |q|
        q.eq("creatorID",session[:object_id]) unless  @user["role_name"].eql?("User")
        q.eq("userID",session[:object_id]) if @user["role_name"].eql?("User")
    end.get.uniq{|x| x["cointTypeName"]}

    coin_type_details = @parse_client.query("CoinTypes").tap do |q|
      q.eq("creatorID",session[:object_id])
    end.get

    @coin_types = coin_type_details.collect{|coin_type| coin_type["cointTypeName"]}

    @triggers_details = @parse_client.query("Challenges").tap do |q|
      q.eq("creatorID",session[:object_id])
    end.get
  end
  
  def set_graph coin_type
    seven_triggers = @parse_client.query("Challenges").tap do |trigger|
        trigger.eq("creatorID",session[:object_id])
        trigger.eq("coinTypeName",coin_type)
      end.get
    @triggers = seven_triggers.collect{|trigger| {date: (trigger["createdAt"]).to_time.strftime("%d"),
                                                  amount: trigger["amountCoinsReward"]}}
  end

end