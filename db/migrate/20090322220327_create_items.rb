class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string  :sku
      t.string  :name
      t.text    :description
      t.integer :retail_price_cents
      t.boolean :active, :default => false
      t.timestamps
    end
    
    add_index :items, :sku, :unique => true
    add_index :items, :active
  end

  def self.down
    drop_table :items
  end
end
