class MessagesController < ApplicationController
	include HTTParty

	def index
		Rails.logger.info "<<<<<<<<#{params.inspect}"
		messages = params["entry"].first["messaging"]
		sender_id = messages.first["sender"]["id"]
		unless messages.length.zero?
			messages.each do |event|
				if event["message"] && event["message"]["text"]
					text = Hash.new
					text['text'] = "Echo: " + event["message"]["text"].to_s
					send_message(sender_id,text)
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

	private 

	def send_message(recipient_id,text)
		HTTParty.post(Settings.fb_url,
			:qs => {access_token: Settings.fb_page_access_token},
			:json => {
					:recipient => {:id => recipient_id},
					:message => text
				}
			)
	end

end
