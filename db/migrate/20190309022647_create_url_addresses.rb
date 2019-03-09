class CreateUrlAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :url_addresses do |t|
      t.string :address

      t.timestamps
    end
  end
end
