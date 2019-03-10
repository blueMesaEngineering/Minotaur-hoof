class PdfDataModelSerializer
  include FastJsonapi::ObjectSerializer
  # attributes :id, :address, :pdf_version, :producer, :title, :page_count
  belongs_to :temp_url_data_model
end
