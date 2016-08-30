class ApplicationController < ActionController::API
	before_filter :get_actions


	def get_actions
		puts "_____________hello__________"
		@actions = {
		  send: -> (request, response) {
		  	send_text_message(sender_id, response['text'])
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
		@actions
	end
	
end
