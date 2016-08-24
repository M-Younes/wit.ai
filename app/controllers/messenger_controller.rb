class MessengerController < Messenger::MessengerController


	def webhook
		messages = params["entry"].first["messaging"]
		sender_id = messages.first["sender"]["id"]
		unless messages.length.zero?
			messages.each do |event|
				if event["message"] && event["message"]["text"]
					text = event["message"]["text"].to_s
					send_message(sender_id,text)
				end
			end
		end
		render :nothing => true, :status => 200		
	end


	def send_message(user_id, message)
	  Messenger::Client.send(
	    Messenger::Request.new(
	      Messenger::Elements::Text.new(text: 'Testing bot echo '+'message'),user_id)
	  )		
	end
end
