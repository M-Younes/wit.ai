class MessagesController < ApplicationController

	def index
		render json: "agent", status: 200
	end

	def webhook
		Rails.logger.info "<<<<<<<<#{params.inspect}"
	end

end
