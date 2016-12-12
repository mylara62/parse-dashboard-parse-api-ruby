class HistoriesController < ApplicationController
	before_action :parse_authenticate
	before_action :authenticate_user
	before_action :set_user
	before_action :set_history,only: [:edit,:update_history,:show,:destroy]
	before_action :history_params,only: [:update_history]
  before_action :set_history_details,only: [:index]

  include ParseParams

	def edit;end

	def show;end

	def update_history;end

  def destroy
    begin
      @history.parse_delete
      redirect_to dashboard_path
    rescue Parse::ParseProtocolError => e
      flash[:error] = "server execution time expired "
      redirect_to error_path
    rescue Parse::ConnectionError => e
      flash[:error] = "ConnectionError"
      redirect_to error_path
    end
  end

  def history_coin_tag_rank
    if params[:type].eql?("Sender")
      @sender_history_ranks = set_history_rank(params[:coinType],
                                      params[:tag])
    elsif params[:type].eql?("Receiver")
      @receiver_history_ranks = set_history_rank(params[:coinType],
                                      params[:tag])
    else
      history_rank_details
    end
    respond_to do |format|
      format.js
    end
  end

	private

	def history_params
    save_history_params
    @history.save
    redirect_to history_path(@history["objectId"])
	end
	
	def set_history
  	history = @parse_client.query("SendHistory")		
  	@history = history.eq("objectId", params[:id]).get.first
  end

  def set_history_details
    @coin_types = @parse_client.query("CoinTypes").tap do |q|
      q.eq("creatorID",session[:object_id])
    end.get.collect{|coin_type| coin_type["cointTypeName"]}
    @hash_tags_details = @parse_client.query("HashTags").tap do |q|
      q.eq("creatorID",session[:object_id])
    end.get.collect{|tag| tag["TagName"]}.reject { |item| item.nil? || item == '[]' }
    history_tag = @hash_tags_details.find_all{|e| @hash_tags_details.count(e) > 1}.present?
    history_tag ? @history_tags = @hash_tags_details.uniq! : @history_tags = @hash_tags_details
    history_rank_details
  end

  def history_rank_details
    if ( !(@coin_types.blank?) && !(@history_tags.blank?) )
      @sender_history_ranks = set_history_rank(@coin_types.first,@history_tags.first)
      @receiver_history_ranks = set_history_rank(@coin_types.first,@history_tags.first)
    end
  end
  
  def set_history_rank coin_type,tag_name
    send_history_details = @parse_client.query("SendHistory").tap do |send_history|
      send_history.eq("coinTypeName",coin_type)
      send_history.eq("tagName",tag_name) 
    end.get
    ranking_amount = send_history_details.map{|send_history| 
    																					[send_history["senderName"],
    																					send_history["receiverName"],
    																					send_history["amountReceived"]]}
		ranking_list = ranking_amount.collect{|sender_name,receiver_name,amount| 
																				 {sender_name: sender_name,
																				 	receiver_name: receiver_name,
																				 	total_amount: amount.to_i}}
		ranking_list.sort_by{|hash| hash[:total_amount]}.reverse!
  end
end
