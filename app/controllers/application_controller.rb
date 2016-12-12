class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

 def parse_authenticate
 		@parse_client = Parse.create(application_id: ENV['PARSE_APPLICATION_ID'],
 						                     api_key: ENV['PARSE_APPLICATION_KEY'],
 						                     host: ENV['PARSE_APPLICATION_HOST'], 
 						                     path: ENV['PARSE_APPLICATION_PATH'])
 end

  def authenticate_user
  	if session[:object_id].blank? 
  		redirect_to sign_in_users_path
  		flash[:notice] = "please enter username/password"
  	end
  end

  def set_user
  	begin
      @user = @parse_client.query("_User").eq("objectId", session[:object_id]).get.first
  	rescue Parse::ConnectionError => e
	 		flash[:error] = "ConnectionError"
			redirect_to error_path
	  rescue Parse::ParseProtocolError => e
		 	flash[:error] = "server execution time expired"
			redirect_to error_path
		end
  end
end

