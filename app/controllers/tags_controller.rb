class TagsController < ApplicationController
	before_action :parse_authenticate
	before_action :authenticate_user
	before_action :set_user
	before_action :set_tag,only: [:edit,:update_tag,:destroy,:show]
	before_action :tag_params,only: [:create_tag,:update_tag]
	before_action :coin_type_details,only: [:new,:edit]
	before_action :set_tag_details,only: [:index]
	
	include ParseParams

	def new;end

	def create_tag;end

	def edit;end

	def update_tag;end

	def show;end
	
	def destroy;end

	def index;end

	private 

  def tag_params
		begin
	  	params[:action].eql?("create_tag") ? 
	  	@tag = @parse_client.object("HashTags") : @tag = @tag
	  	save_params
			redirect_to tag_path(@tag["objectId"])
	  rescue Parse::ParseProtocolError => e
		 	flash[:error] = "server execution time expired"
		 	redirect_to error_path
		rescue Parse::ConnectionError => e
		 	flash[:error] = "ConnectionError"
		 	redirect_to error_path
		end
  end

  def save_params
  	save_tag_params
		@tag.save
  end

  def set_tag
  	tag = @parse_client.query("HashTags")		
  	@tag = tag.eq("objectId", params[:id]).get.first
  end

  def coin_type_details

  	coin_type_details = @parse_client.query("CoinTypes").tap do |q|
      q.eq("creatorID",session[:object_id])
    end.get

    @coin_types = coin_type_details.collect{|coin_type| coin_type["objectId"]}

  	@users = @parse_client.query("_User").tap do |user|
  		 user.eq("role_name","User")
  	end.get

  	@user_names = @users.collect{|user| user["username"]}

  end
  
  def set_tag_details
  	@hash_tags_details = @parse_client.query("HashTags").tap do |q|
  		q.eq("creatorID",session[:object_id])
  	end.get
  end
end
