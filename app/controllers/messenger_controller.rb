class MessengerController < Messenger::MessengerController

	def webhook
		messages = params["entry"].first["messaging"]
		sender_id = messages.first["sender"]["id"]
		unless messages.length.zero?
			messages.each do |event|
				if event["message"] && event["message"]["text"]
					text = event["message"]["text"].to_s
					send_text_message(sender_id, "Welcome to Says facebook bot..")
					send_text_message(sender_id, "I am still under deveolpment :D")
					send_text_message(sender_id, "Meanwhile, here is the top 3 stories from Says.com ")
					send_bubbles(sender_id)
				end
			end
		end
		render :nothing => true, :status => 200		
	end


	def send_text_message(user_id, message)
	  Messenger::Client.send(
	    Messenger::Request.new(
	      Messenger::Elements::Text.new(text: 'Testing bot echo '+'message'),user_id)
	  )		
	end

	def send_bubbles(user_id)
		Messenger::Client.send(
			Messenger::Request.new(
				Messenger::Templates::Generic.new(
					elements: bubbles), user_id))
	end

	def bubbles(top_stories=[])
		stories_bubbles = Array.new
		top_stories = get_top_stories if top_stories.empty?
			top_stories.each do |story|
				bubble = Messenger::Elements::Bubble.new(
				  title: story["title"],
				  subtitle: story["description"],
				  item_url: story["url"],
				  image_url: story["cover_image_small"],
				  buttons: [
				    Messenger::Elements::Button.new(
				      type: 'web_url',
				      title: 'Read story',
				      value: story["url"]
				    )
				  ]
				)
				stories_bubbles << bubble
			end
			stories_bubbles
	end

	def get_top_stories
		begin 
			request = HTTParty.get(Settings.says_top_stories_url)
			request.parsed_response
		rescue
			Array.new
		end
	end	
end
