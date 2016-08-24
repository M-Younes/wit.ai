class MessengerController < Messenger::MessengerController

	def webhook
		messages = params["entry"].first["messaging"]
		sender_id = messages.first["sender"]["id"]
		unless messages.length.zero?
			messages.each do |event|
				if event["message"] && event["message"]["text"]
					text = event["message"]["text"].to_s
					FacebookBot.new.send_text_message(sender_id, "This is a bot testing. Echo " + "#{text}")
				end
			end
		end
		render :nothing => true, :status => 200		
	end
end
