class CreateUrlDataModels < ActiveRecord::Migration[5.2]
  def change
    create_table :url_data_models do |t|
      t.string :url_address
      t.decimal :pdf_version
      t.string :producer
      t.string :title
      t.string :metadata
      t.integer :page_count

      t.timestamps
    end
  end
end
