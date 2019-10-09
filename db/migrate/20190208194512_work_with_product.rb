class WorkWithProduct < ActiveRecord::Migration[5.2]
  def self.up
    add_column :administrators, :work_with_product, :string
  end

  def self.down
    remove_column :administrators, :work_with_product, :string
  end
end
