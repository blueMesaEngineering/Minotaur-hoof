class CreateTempUrlDataModels < ActiveRecord::Migration[5.2]
  def change
    create_table :temp_url_data_models do |t|
      t.string :address
      t.decimal :pdf_version
      t.string :producer
      t.string :title
      t.string :metadata
      t.integer :page_count

      t.timestamps
    end
  end
end
