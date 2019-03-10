class StaticPagesController < ApplicationController
  		
	def home
	
	end

	def help
	
	end

  	def about
  		
  	end

  	def contact
  		
  	end

    def serializedJSON

      render json: UrlDataModel.find(params[:id])
      
    end

end