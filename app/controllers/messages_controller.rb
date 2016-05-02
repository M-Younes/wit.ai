class MessagesController < ApplicationController

	def index
		render json: "agent", status: 200
	end

	def webhook
		challenge = params["hub.challenge"] 
		if params["hub.verify_token"].to_s == Digest::SHA1.hexdigest(Settings.token)
			render :json => challenge, :status => 200
		else
			render :json => "Error, wrong validation token", :status => 406
		end
	end

end
