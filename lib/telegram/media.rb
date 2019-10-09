require_relative 'channel.rb'
require_relative 'keyboard.rb'
require_relative 'message.rb'

module Telegram
  class DocumentBase
    include Virtus.model
    attribute :chat, Channel
    attribute :caption, String
    attribute :parse_mode, String
    attribute :disable_notification, Boolean
    attribute :reply_to, Message
    attribute :reply_markup, Keyboard

    def chat_friendly_name
      chat.friendly_name
    end
  end

  class Photo < DocumentBase
    attribute :id, String

    def send_with(bot)
      bot.send_photo(self)
    end

    def to_h
      document = {
        photo: source,
        chat_id: chat.id
      }

      document[:reply_to_message_id] = reply_to.id unless reply_to.nil?
      document[:parse_mode] = parse_mode unless parse_mode.nil?
      document[:caption] = caption unless caption.nil?
      document[:disable_notification] = disable_notification unless disable_notification.nil?
      document[:reply_markup] = reply_markup.to_h.to_json unless reply_markup.nil?

      document
    end

    protected

    def source
      id
    end

    def get_id_from(resp)
      resp['photo']
      .sort { |photo| photo['file_size'] }
      .first['file_id']
    end
  end
end
