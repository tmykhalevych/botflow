class AllTables < ActiveRecord::Migration[5.2]
  def self.up
    # User table definition
    create_table :users do |t|
      t.string     :first_name
      t.string     :second_name
      t.integer    :telegram_id
      t.string     :telegram_username
      t.string     :city
      t.integer    :phone_number
      t.integer    :post_type
      t.integer    :post_office
      t.integer    :state
      t.references :order
    end

    # Order table definition
    create_table :orders do |t|
      t.text       :delivery_info
      t.integer    :price
      t.integer    :discount
      t.integer    :status
      t.references :item
      t.timestamps
    end

    # Item table definition
    create_table :items do |t|
      t.integer :count
      t.integer :product_id
      t.integer :price
    end

    # Product table definition
    create_table :products do |t|
      t.string  :name
      t.text    :description
      t.string  :product_id
      t.integer :cost
      t.integer :price
      t.string  :landscape
      t.string  :images, array: true, default: []
      t.integer :in_stock
    end
  end

  def self.down
    drop_table :users
    drop_table :products
    drop_table :items
    drop_table :orders
  end
end
