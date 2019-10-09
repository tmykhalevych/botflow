class SetupAdminsTable < ActiveRecord::Migration[5.2]
  def self.up
    # Administrator table definition
    create_table :administrators do |t|
      t.string  :first_name
      t.string  :second_name
      t.integer :telegram_id
      t.integer :state
      t.integer :mode # superuser, sales, stockroom staff, etc.
      t.boolean :logged_in
    end
  end

  def self.down
    drop_table :administrators
  end
end
