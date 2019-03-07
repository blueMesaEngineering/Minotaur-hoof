class UrlDataModel < ApplicationRecord


	attr_accessor :url_address, :pdf_version, :producer, :title, :metadata, :page_count

	





	#------------------------------------------------------------------------------
	#Name:                          initialize
	#
	#Purpose:                       To provide a constructor for the class.
	#
	#Precondition:                  url_data_model has been instantiated.
	#
	#Postcondition:                 url_data_model has been initialized.
	#
	#                                   -----
	#
	#Calls:                         N/A
	#
	#Called By:                     class
	#
	#                                   -----
	#Additional Comments: 			
	#
	#Programmer:                    ND Guthrie
	#Date:                          20190305
	#------------------------------------------------------------------------------

	def initialize(attributes = {})

		@url_address		= attributes[:url_address]
		@pdf_version 		= attributes[:pdf_version]
		@producer 			= attributes[:producer]
		@title 				= attributes[:title]
		@metadata 			= attributes[:metadata]
		@page_count 		= attributes[:page_count]

		buildModelFromURLViaPDF

	end







	#------------------------------------------------------------------------------
	#Name:                          after_initialize
	#
	#Purpose:                       To provide a constructor for the class.
	#
	#Precondition:                  An instance of UrlDataModel, url_data_model,
	# 								exists.
	#
	#Postcondition:                 url_data_model is populated by 
	# 								buildModelFromURLViaPDF
	#
	#                                   -----
	#
	#Calls:                         buildModelFromURLViaPDF
	#
	#Called By:                     class
	#
	#                                   -----
	#Additional Comments: 			
	#
	#Programmer:                    ND Guthrie
	#Date:                          20190305
	#------------------------------------------------------------------------------

	def after_initialize()

		buildModelFromURLViaPDF

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

	def buildModelFromURLViaPDF

		convertURLToPDF()
		readPDFData()
		deletePDF()
		
	end







	#------------------------------------------------------------------------------
	#Name:                          convertURLToPDF()
	#
	#Purpose:                       To convert a URL to PDF
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

		require "bundler/setup"
		Bundler.require

		DocRaptor.configure do |dr|

		  dr.username  = "YOUR_API_KEY_HERE" # this key works for test documents
		  # dr.debugging = true

		end

		$docraptor = DocRaptor::DocApi.new

		begin

			logPathName 		= "./storage/Logs/standardOutput/output.txt"
			errorLogPathName	= "./storage/Logs/Error/"
			pathName 			= "./storage/PDFs/"
			# url 				= "http://docraptor.com/examples/invoice.html"
			url 				= "http://www.docraptor.com"
			@url_address = url

			fileNamePDF 		= "docraptor-ruby.pdf"


		  	create_response = $docraptor.create_async_doc(
			    test:             		true,                               # test documents are free but watermarked
			    document_url:   		url, 								# or use a url
			    name:             		fileNamePDF,                        # help you find a document later
			    document_type:    		"pdf",                              # pdf or xls or xlsx
		  	)

		  	loop do
			    status_response = $docraptor.get_async_doc_status(create_response.status_id)

			    #puts "doc status: #{status_response.status}"
			    
			    case status_response.status
			    
			    when "completed"
			      	doc_response = $docraptor.get_async_doc(status_response.download_id)
			      	File.open("./storage/PDFs/docraptor-ruby.pdf", "wb") do |file|
	        			file.write(doc_response)
					end
			      	#puts "Wrote PDF to " + pathName + fileNamePDF

			      break
			    
			    when "failed"

			      	#puts "FAILED"
			      	#puts status_response
			      	break

			    else

			      	sleep 1

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
	#Purpose:                       To read the data from the newly created PDF
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
			
			@pdf_version 	= reader.pdf_version
			# @producer 		= reader.producer
			# @title 			= reader.title
			@metadata 		= reader.metadata
			@page_count 	= reader.page_count

		end
		
	end





	#------------------------------------------------------------------------------
	#Name:                          deletePDF()
	#
	#Purpose:                       To delete created PDF after reading
	#
	#Precondition:                  PDF exists in ./storage/PDFs/docraptor-ruby.pdf
	#
	#Postcondition:                 ./storage/PDFs/ is empty.
	#
	#                                   -----
	#
	#Calls:                         N/A
	#
	#Called By:                     index
	#
	#                                   -----
	#Additional Comments: 			This function utilizes the pdfreader gem as per
	# 								design specification requirements. It extracts
	# 								the 
	# 
	#Programmer:                    ND Guthrie
	#Date:                          20190305
	#------------------------------------------------------------------------------

	def deletePDF
		
		require 'fileutils'

		FileUtils.rm_rf('./storage/PDFs/docraptor-ruby.pdf')

	end

end
