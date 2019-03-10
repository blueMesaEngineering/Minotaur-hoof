class TempUrlDataModel < ApplicationRecord
	has_one :pdf_data_model_serializer
	attr_accessor :id, :address, :pdf_version, :producer, :title, :metadata, :page_count
end
