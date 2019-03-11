class PdfDataModelSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :address, :pdf_version, :producer, :title, :page_count
  
end
