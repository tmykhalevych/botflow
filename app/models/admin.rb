require_relative 'application_record.rb'

class Administrator < ApplicationRecord
  @@states_map = {
    idle:                    0,
    admin_login:             1,
    product_create:          2,
    product_destroy:         3,
    product_read:            4,
    product_update:          5,
    product_name:            6,
    product_description:     7,
    product_cost:            8,
    product_price:           9,
    product_stock:          10
  }.freeze

  validates :telegram_id, presence: true

  def self.create_from(message)
    admin = Administrator.create(telegram_id: message.from.id)
    admin.first_name = message.from.first_name if message.from.first_name
    admin.second_name = message.from.last_name if message.from.last_name
    admin.save
    admin
  end

  def self.state(st)
    @@states_map[st]
  end

  def self.state_str(st)
    @@states_map.invert[st].to_s
  end
end
