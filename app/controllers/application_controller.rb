require_all 'app/models'

module App
  class ApplicationController
    include R18n::Helpers

    def initialize(opts)
      @message = opts.fetch(:message)
      @bot_api = opts.fetch(:bot_api)
      @admin = opts.fetch(:admin)
      @command = @message.get_command_for(@bot_api)
      @media_factory = opts.fetch(:media_factory)
    end

    def start
      send_text_response(t.app.invalid_command(message.from.first_name))
      send_photo('no_photo_available.png', t.product.update(
        'product.product_id',
        'product.name',
        'product.description',
        'product.cost',
        'product.price',
        'product.in_stock'
      )) # TODO: delete this :)
    end

    protected
    attr_accessor :message, :bot_api, :admin, :command
    attr_reader :media_factory

    def send_text_response(msg)
      reply { |resp| resp.text = msg }
    end

    def send_photo(name, caption = nil)
      photo = media_factory.newPhoto(name)
      photo.chat = message.chat
      photo.caption = caption if caption
      photo.send_with(bot_api)
    end

    def reply
      message.reply do |resp|
        yield(resp)
        resp.send_with(bot_api)
      end
    end

    def hide_custom_keyboard
      if admin.custom_keyboard then
        admin.custom_keyboard = false
        admin.save
        
        reply do |resp|
          resp.reply_markup = Telegram::ReplyKeyboardRemove.new
          resp.text = t.app.remove_markup
        end
      end
    end

    def set_custom_keyboard
      keyboard = Telegram::ReplyKeyboardMarkup.new
      keyboard.selective = true
      admin.custom_keyboard = true
      admin.save
      keyboard
    end
  end
end
