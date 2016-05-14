class MessagesController < ApplicationController
	require 'wit'

	def index
		messages = params["entry"].first["messaging"]
		sender_id = messages.first["sender"]["id"]
		unless messages.length.zero?
			messages.each do |event|
				if event["message"] && event["message"]["text"]
					text = event["message"]["text"].to_s
					FacebookBot.new.send_generic_message(sender_id, "This is a bot testing. Echo" + "#{text}")
				end
			end
		end
		render :nothing => true, :status => 200
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
