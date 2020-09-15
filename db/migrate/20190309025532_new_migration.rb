class NewMigration < ActiveRecord::Migration[5.2]
  def change
  	# drop_table :url_data_models
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
