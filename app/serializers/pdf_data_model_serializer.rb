class PdfDataModelSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :address, :pdf_version, :producer, :title, :metadata, :page_count
  
end
