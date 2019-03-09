class UrlAddressesController < ApplicationController


	def index
		@url_addresses = UrlAddress.all
	end

  	def new
  	end

  	def show

		@url_address = UrlAddress.find(params[:id])
		
  	end

  	def create

		@url_address = UrlAddress.new(url_addresses_params)
		@url_address.save

		redirect_to @url_address

  	end

  	private

		def url_addresses_params

			params.require(:url_address).permit(:address)
			
		end


end
