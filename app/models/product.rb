require_relative 'application_record.rb'

class Product < ApplicationRecord
  validates :product_id, presence: true

  def self.create_with_id(id)
    return nil if !!Product.find_by_id(id)
    product = Product.create(
      product_id: id,
      name: id,
      description: '',
      cost: 0,
      price: 0,
      in_stock: 0,
      landscape: ''
    )
    product.save
    product
  end

  def self.find_by_id(id)
    Product.find_by(product_id: id)
  end
end
