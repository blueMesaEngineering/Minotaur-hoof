class UrlDataModelsController < ApplicationController

	Bundler.require
	require 'fileutils'
	require "bundler/setup"
	require 'json/ext'
	require 'active_support'







    #------------------------------------------------------------------------------
    #Name:                          index()
    #
    #Purpose:                       Controller for index.
    #
    #Precondition:                  UrlDataModel exists.
    #
    #Postcondition:                 
    #
    #                                   -----
    #
    #Calls:                         N/A
    #
    #Called By:                     url_data_models_controller
    #
    #                                   -----
    #Additional Comments:           
    # 
    #Programmer:                    ND Guthrie
    #Date:                          20190310
    #------------------------------------------------------------------------------

	def index

		@url_data_models = UrlDataModel.all

	end







    #------------------------------------------------------------------------------
    #Name:                          new()
    #
    #Purpose:                       Controller for new.
    #
    #Precondition:                  
    #
    #Postcondition:                 
    #
    #                                   -----
    #
    #Calls:                         N/A
    #
    #Called By:                     url_data_models_controller
    #
    #                                   -----
    #Additional Comments:           
    # 
    #Programmer:                    ND Guthrie
    #Date:                          20190310
    #------------------------------------------------------------------------------

	def new
		
	end








    #------------------------------------------------------------------------------
    #Name:                          show()
    #
    #Purpose:                       Controller for show.
    #
    #Precondition:                  
    #
    #Postcondition:                 
    #
    #                                   -----
    #
    #Calls:                         N/A
    #
    #Called By:                     url_data_models_controller
    #
    #                                   -----
    #Additional Comments:           
    # 
    #Programmer:                    ND Guthrie
    #Date:                          20190310
    #------------------------------------------------------------------------------

	def show

		@url_data_model = UrlDataModel.find(params[:id])
		
	end








    #------------------------------------------------------------------------------
    #Name:                          showJSON()
    #
    #Purpose:                       Controller for showJSON.
    #
    #Precondition:                  
    #
    #Postcondition:                 
    #
    #                                   -----
    #
    #Calls:                         N/A
    #
    #Called By:                     url_data_models_controller
    #
    #                                   -----
    #Additional Comments:           
    # 
    #Programmer:                    ND Guthrie
    #Date:                          20190310
    #------------------------------------------------------------------------------

	def showJSON

		render json: UrlDataModel.find(params[:id])

	end








    #------------------------------------------------------------------------------
    #Name:                          create()
    #
    #Purpose:                       Controller for create.
    #
    #Precondition:                  
    #
    #Postcondition:                 
    #
    #                                   -----
    #
    #Calls:                         N/A
    #
    #Called By:                     url_data_models_controller
    #
    #                                   -----
    #Additional Comments:           
    # 
    #Programmer:                    ND Guthrie
    #Date:                          20190310
    #------------------------------------------------------------------------------

	def create

		buildModelFromURLViaPDF

		parseMetadata

		@url_data_model = UrlDataModel.new(url_data_model_params)

		if (validateAddress(params[:url_data_model][:address]) == 0)

			redirect_to error_path

		else

			@url_data_model.save
			flash[:notice] = "The model has been created."
			redirect_to @url_data_model

		end
	
	end








    #------------------------------------------------------------------------------
    #Name:                          destroy()
    #
    #Purpose:                       Controller for destroy.
    #
    #Precondition:                  
    #
    #Postcondition:                 
    #
    #                                   -----
    #
    #Calls:                         N/A
    #
    #Called By:                     url_data_models_controller
    #
    #                                   -----
    #Additional Comments:           
    # 
    #Programmer:                    ND Guthrie
    #Date:                          20190310
    #------------------------------------------------------------------------------

	def destroy

		@url_data_model = UrlDataModel.find(params[:id])
		@url_data_model.destroy

		redirect_to url_data_models_path		
		
	end










    #------------------------------------------------------------------------------
    #Name:                          validateAddress()
    #
    #Purpose:                       To validate the user input for the URL address.
    #
    #Precondition:                  
    #
    #Postcondition:                 
    #
    #                                   -----
    #
    #Calls:                         N/A
    #
    #Called By:                     url_data_models_controller
    #
    #                                   -----
    #Additional Comments:           
    # 
    #Programmer:                    ND Guthrie
    #Date:                          20190321
    #------------------------------------------------------------------------------

	def validateAddress(tempString)

		tempString.strip!

		if (tempString =~ /https?:\/\/[\S]+/)

			if ((tempString =~ /.com/) || (tempString =~ /.co/) || (tempString =~ /.edu/) || (tempString =~ /.edu/) || (tempString =~ /.org/))
				
				return 1
			else
				
				return 0

			end		

		else

			return 0

		end
		
	end









	#------------------------------------------------------------------------------
	#Name:                          buildModelFromURLViaPDF
	#
	#Purpose:                       To provide a control architecture for the 
	# 								functionality required to convert an HTML file
	# 								located at a given URL to a PDF.
	#
	#Precondition:                  HTML file located at given URL exists.
	#
	#Postcondition:                 HTML file is converted to PDF.
	#
	#                                   -----
	#
	#Calls:                         convertURLToPDF()
	# 								readPDFData()
	#
	#Called By:                     printable_controller.rb
	#
	#                                   -----
	#Additional Comments: 			This imethod is for the UrlDataModel 
	# 								controller based on the DocRaptor example at
	# 								https://docraptor.com/blog/adding-pdf-generation-to-your-rails-app/
	#
	#Programmer:                    ND Guthrie
	#Date:                          20190305
	#------------------------------------------------------------------------------

	def buildModelFromURLViaPDF()

		convertURLToPDF()
		readPDFData()
	end







	#------------------------------------------------------------------------------
	#Name:                          convertURLToPDF()
	#
	#Purpose:                       To convert a URL to PDF.
	#
	#Precondition:                  URL exists
	#
	#Postcondition:                 PDF converted from the given URL exists and
	# 								is located in ./storage/PDFs.
	#
	#                                   -----
	#
	#Calls:                         N/A
	#
	#Called By:                     buildModelFromURLViaPDF
	#
	#                                   -----
	#Additional Comments: 			This is a modified version of the async.rb file
	#  								used for asynchronous HTML to PDF conversion.
	# 								Error logging has been added, and the converted
	# 								file is stored in ./storage/PDFs.
	# 
	#Programmer:                    ND Guthrie
	#Date:                          20190304
	#------------------------------------------------------------------------------

	def convertURLToPDF()

		DocRaptor.configure do |dr|

		  dr.username  = "YOUR_API_KEY_HERE" # this key works for test documents

		end

		$docraptor = DocRaptor::DocApi.new

		begin

			logPathName 		= "./storage/Logs/standardOutput/output.txt"
			errorLogPathName	= "./storage/Logs/Error/"
			pathName 			= "./storage/PDFs/"
			fileNamePDF 		= "docraptor-ruby.pdf"
			address 			= params[:url_data_model][:address]

			if address == ""
				flash[:notice] = "The address cannot be empty."
			else

			  	create_response = $docraptor.create_async_doc(
				    test:             		true,                               # test documents are free but watermarked
				    document_url:   		address,							# or use a url
				    name:             		fileNamePDF,                        # help you find a document later
				    document_type:    		"pdf",                              # pdf or xls or xlsx
			  	)

			  	loop do
				    status_response = $docraptor.get_async_doc_status(create_response.status_id)

				    case status_response.status
				    
				    when "completed"
				      	doc_response = $docraptor.get_async_doc(status_response.download_id)
				      	File.open("./storage/PDFs/docraptor-ruby.pdf", "wb") do |file|
		        			file.write(doc_response)
						end

				      	break
				    
				    when "failed"

				    	break

				    else

				      	sleep 1

			    end

			end
		 
		end

		rescue DocRaptor::ApiError => error
		  	
		    #puts "#{error.class}: #{error.message}"
		    #puts error.code          # HTTP response code
		    #puts error.response_body # HTTP response body
		    #puts error.backtrace[0..3].join("\n")

		end		
		
	end






	#------------------------------------------------------------------------------
	#Name:                          readPDFData()
	#
	#Purpose:                       To read the data from the newly created PDF.
	#
	#Precondition:                  PDF exists
	#
	#Postcondition:                 PDF converted from the given URL exists and
	# 								is located in ./storage/PDFs.
	#
	#                                   -----
	#
	#Calls:                         N/A
	#
	#Called By:                     buildModelFromURLViaPDF
	#
	#                                   -----
	#Additional Comments: 			This function utilizes the pdfreader gem as per
	# 								design specification requirements. It extracts
	# 								the pdf_version, metadata, and page_count, 
	# 								provided they exist.
	# 
	#Programmer:                    ND Guthrie
	#Date:                          20190304
	#------------------------------------------------------------------------------

	def readPDFData

		require 'rubygems'
		require 'pdf/reader'

		fileName = "./storage/PDFs/docraptor-ruby.pdf"

		PDF::Reader.open(fileName) do |reader|

			params[:url_data_model][:pdf_version] = reader.pdf_version
			params[:url_data_model][:metadata] = reader.metadata.inspect
			params[:url_data_model][:page_count] = reader.page_count
			@pageInfo = reader.info.inspect

		end

	end





	#------------------------------------------------------------------------------
	#Name:                          deletePDF()
	#
	#Purpose:                       To delete created PDF after reading.
	#
	#Precondition:                  PDF exists in ./storage/PDFs/docraptor-ruby.pdf
	#
	#Postcondition:                 ./storage/PDFs/ is empty.
	#
	#                                   -----
	#
	#Calls:                         N/A
	#
	#Called By:                     buildModelFromURLViaPDF
	#
	#                                   -----
	#Additional Comments: 			This function removes the stored PDF. 
	# 
	#Programmer:                    ND Guthrie
	#Date:                          20190305
	#------------------------------------------------------------------------------

	def deletePDF

		FileUtils.rm_rf('./storage/PDFs/docraptor-ruby.pdf')

	end






	#------------------------------------------------------------------------------
	#Name:                          parseMetadata()
	#
	#Purpose:                       To extract data from @pageInfo. 
	#
	#Precondition:                  PDF exists in ./storage/PDFs/docraptor-ruby.pdf
	#
	#Postcondition:                 params[:url_data_model][:producer] and
	# 								params[:url_data_model][:title] have been
	# 								populated.
	#
	#                                   -----
	#
	#Calls:                         N/A
	#
	#Called By:                     create
	#
	#                                   -----
	#Additional Comments: 			
	# 
	#Programmer:                    ND Guthrie
	#Date:                          20190309
	#------------------------------------------------------------------------------

	def parseMetadata
	
		if(@pageInfo.include? 'Producer')	

			firstIndex = @pageInfo.index('Producer') + 11
			params[:url_data_model][:producer] = @pageInfo[firstIndex..(@pageInfo[firstIndex + 2..@pageInfo.size()].index(',')+firstIndex)]
		
		end

		if(@pageInfo.include? 'Title')

			firstIndex = @pageInfo.index('Title') + 8
			
			if(@pageInfo[firstIndex..@pageInfo.size()].include? ',')
				params[:url_data_model][:title] = @pageInfo[firstIndex..(@pageInfo[firstIndex + 2..@pageInfo.size()].index(',')+firstIndex)]
			else
				params[:url_data_model][:title] = @pageInfo[firstIndex..((@pageInfo.index '}') - 2)]
			end
		
		end
	
	end



	private

		def url_data_model_params

			params.require(:url_data_model).permit(:address, :pdf_version, :producer, :title, :metadata, :page_count)
			
		end

end
