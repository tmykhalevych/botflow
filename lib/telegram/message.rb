require_relative "user.rb"
require_relative "channel.rb"
require_relative "keyboard.rb"

module Telegram
  class Message
    include Virtus.model
    attribute :message_id, Integer
    attribute :from, User
    attribute :date, DateTime
    attribute :chat, Channel
    attribute :forward_from, User
    attribute :forward_from_chat, Channel
    attribute :forward_from_message_id, Integer
    attribute :forward_signature, String
    attribute :forward_date, DateTime
    attribute :reply_to_message, Message
    attribute :edit_date, DateTime
    attribute :media_group_id, String
    attribute :author_signature, String
    attribute :text, String
    attribute :entities, Array
    attribute :caption_entities, Array
    #attribute :document, Document
    #attribute :animation, Animation
    attribute :photo, Array
    #attribute :sticker, Sticker
    #attribute :video, Video
    #attribute :voice, Voice
    #attribute :video_note, VoiseNote
    #attribute :caption, Contact
    
    alias_method :user, :from
    alias_method :id, :message_id
    alias_method :to_i, :id

    def reply(&block)
      reply = OutMessage.new(chat: chat)
      yield reply if block_given?
      reply
    end

    def get_command_for(bot)
      text && text.sub(Regexp.new("@#{bot.identity.username}($|\s|\.|,)", Regexp::IGNORECASE), '').strip
    end
  end

  class OutMessage
    include Virtus.model
    attribute :chat, Channel
    attribute :text, String
    attribute :reply_to, Message
    attribute :parse_mode, String
    attribute :disable_web_page_preview, Boolean
    attribute :reply_markup, Keyboard

    def send_with(bot)
      bot.send_message(self)
    end

    def chat_friendly_name
      chat.friendly_name
    end

    def to_h
      message = {
          text: text,
          chat_id: chat.id
      }

      message[:reply_to_message_id] = reply_to.id unless reply_to.nil?
      message[:parse_mode] = parse_mode unless parse_mode.nil?
      message[:disable_web_page_preview] = disable_web_page_preview unless disable_web_page_preview.nil?
      message[:reply_markup] = reply_markup.to_h.to_json unless reply_markup.nil?

      message
    end
  end
end
