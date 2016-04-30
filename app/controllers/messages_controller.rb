class MessagesController < ApplicationController

	def index
		render json: "agent", status: 200
	end
end
