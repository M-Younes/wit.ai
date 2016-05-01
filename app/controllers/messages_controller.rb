class MessagesController < ApplicationController

	def index
		render json: "agent", status: 200
	end

	def webhook
		return params["hub.challenge"] if params["hub.verify_token"].to_s == Digest::SHA1.hexdigest(Settings.token)
		'Error, wrong validation token'
	end

end
