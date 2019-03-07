class UrlDataModelsController < ApplicationController




	def new
		
	end




	def show

		@url_data_model = UrlDataModel.find(params[:id])
		
	end



	def create
		# render plain: params[:url_data_model].inspect

		@url_data_model = UrlDataModel.new(url_data_model_params)

		@url_data_model.save
		redirect_to @url_data_model
	
	end

	private

		def url_data_model_params

			params.require(:url_data_model).permit(:url_address, :pdf_version, :producer, :title, :metadata, :page_count)
			
		end

end
