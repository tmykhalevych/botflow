require_relative "application_controller.rb"

module App
  class ProductController < ApplicationController
    def start
      reply do |resp|
        keyboard = set_custom_keyboard
        keyboard.one_time_keyboard = true
        keyboard.keyboard = [
          [text_button('/product_add')],
          [text_button('/product_show')],
          [text_button('/product_edit')],
          [text_button('/product_delete')]
        ]

        resp.reply_markup = keyboard
        resp.text = t.product.start
      end
    end

    def create
      hide_custom_keyboard

      if admin.state == Administrator.state(:product_create) then
        if Product.create_with_id(message.text) then
          admin.state = Administrator.state(:idle)
          admin.save
          send_text_response(t.product.created(message.text))
        else
          send_text_response(t.product.already_exist(message.text))
        end
      else
        admin.state = Administrator.state(:product_create)
        admin.save
        send_text_response(t.product.create)
      end
    end

    def read
      hide_custom_keyboard
      
      if admin.state == Administrator.state(:product_read) then
        product = Product.find_by_id(message.text)
        if product then
          admin.state = Administrator.state(:idle)
          admin.save
          # TODO: Add main landscape here
          send_text_response(t.product.read(
            product.product_id,
            product.name,
            product.description,
            product.cost,
            product.price,
            product.in_stock
          ))
        else
          send_text_response(t.product.dont_exist(message.text))
        end
      else
        admin.state = Administrator.state(:product_read)
        admin.save
        send_text_response(t.product.enter_id)
      end
    end

    def update
      hide_custom_keyboard

      if admin.state == Administrator.state(:product_update) then
        product = Product.find_by_id(message.text)
        if product then
          admin.work_with_product = product.product_id
          admin.save
          send_product_update_hint(product)
        else
          send_text_response(t.product.dont_exist(message.text))
        end
      else
        admin.state = Administrator.state(:product_update)
        admin.save
        send_text_response(t.product.enter_valid_name)
      end
    end

    def destroy
      hide_custom_keyboard
      
      if admin.state == Administrator.state(:product_destroy) then
        product = Product.find_by_id(message.text)
        if product then
          product.destroy
          admin.state = Administrator.state(:idle)
          admin.save
          send_text_response(t.product.deleted(message.text))
        else
          send_text_response(t.product.dont_exist(message.text))
        end
      else
        admin.state = Administrator.state(:product_destroy)
        admin.save
        send_text_response(t.product.enter_to_delete)
      end
    end

    # update methods

    def name
      update_field :name, state: :product_name
    end

    def description
      update_field :description, state: :product_description
    end

    def cost
      update_field :cost, state: :product_cost
    end

    def price
      update_field :price, state: :product_price
    end

    def stock
      update_field :in_stock, state: :product_stock
    end

    def landscape
      # TODO: Add landscape updating here
    end

    def images
      # TODO: Add images updating here
    end

    private

    def update_field(field, state:)
      if admin.work_with_product == '' then
        send_text_response(t.product.edit)
        return
      end
      if admin.state == Administrator.state(state) then
        product = Product.find_by_id(admin.work_with_product)
        product.method("#{field}=".to_sym).call(message.text)
        product.save
        admin.state = Administrator.state(:idle)
        admin.save
        send_text_response(t.product.edited(admin.work_with_product, field, product.send(field)))
        send_product_update_hint(product)
      else
        admin.state = Administrator.state(state)
        admin.save
        send_text_response(t.product.enter_new_val(admin.work_with_product, field))
      end
    end

    def text_button(text)
      Telegram::KeyboardButton.new(text: text)
    end

    def send_product_update_hint(product)
      send_text_response(t.product.update(
            product.product_id,
            product.name,
            product.description,
            product.cost,
            product.price,
            product.in_stock
          ))
    end
  end
end
