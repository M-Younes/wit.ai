class MessengerController < Messenger::MessengerController
require 'wit'
require 'open_weather'

	def webhook
		messages = params["entry"].first["messaging"]
		sender_id = messages.first["sender"]["id"]
		unless messages.length.zero?
			messages.each do |event|
				if event["message"] && event["message"]["text"]
					text = event["message"]["text"].to_s
	actions = {
  send: -> (request, response) {
  	send_text_message(sender_id, response['text'])
    puts("sending... #{response['text']}")
  },
	getForecast: -> (request) {
  	context = request['context']
  	entities = request['entities']
  	loc = first_entity_value(entities, 'location')
  	if loc
      context['forecast'] = get_weather(loc)
  	else
      context['missingLocation'] = true
      context.delete('forecast')
  	end
  	return context
	},  
}	
					client = Wit.new(access_token: Settings.wit_access_token, actions: actions)
					session = 'my-user-session-4'
					context0 = {}
					context1 = client.run_actions(session, text, context0)
					# send_text_message(sender_id, "I am still under deveolpment :D")
					# send_text_message(sender_id, "Meanwhile, here is the top 3 stories from Says.com ")
					# send_bubbles(sender_id)
				end
			end
		end
		render :nothing => true, :status => 200		
	end

	def send_text_message(user_id, message)
	  Messenger::Client.send(
	    Messenger::Request.new(
	      Messenger::Elements::Text.new(text: message),user_id)
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

	def first_entity_value(entities, entity)
	  return nil unless entities.has_key? entity
	  val = entities[entity][0]['value']
	  return nil if val.nil?
	  return val.is_a?(Hash) ? val['value'] : val
	end

	def get_actions 

	end


	def get_weather(loc)
		options = { units: "metric", APPID: Settings.weather_api_key }
		response = OpenWeather::Current.city(loc, options)
		main = response["weather"][0]["main"]
		des  = response["weather"][0]["description"]
		tmp  = response["main"]["temp"]
		"The weather in #{loc} is #{main} (#{des}), with temperature of #{tmp} C"
	end

end
