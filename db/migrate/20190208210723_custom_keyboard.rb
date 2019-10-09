class CustomKeyboard < ActiveRecord::Migration[5.2]
  def self.up
    add_column :administrators, :custom_keyboard, :boolean, default: false
  end

  def self.down
    remove_column :administrators, :custom_keyboard, :boolean
  end
end
