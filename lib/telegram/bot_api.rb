require_relative "message.rb"
require_relative "user.rb"
require_relative "update.rb"

module Telegram
  class WebhookRequest
    include Virtus.model
    attribute :url, String
    attribute :allowed_updates, [String]
  end

  class UpdatesRequest
    include Virtus.model
    attribute :offset, Integer
    attribute :timeout, Integer

    def to_h
      result = super.select { |_, v| !!v }
      Hash[result]
    end
  end

  class BotApi
    def initialize(opts = {})
      @offset = opts[:offset] || 0
      @logger = opts.fetch(:logger)
      @client = opts.fetch(:client)
    end

    def get_me
      @me ||= @client
        .request(:getMe)
        .and_then do |result|
          User.new(result)
        end
        .value!
    end
    alias_method :me, :get_me
    alias_method :identity, :me

    def get_updates(opts = {}, &block)
      return get_last_messages(opts.clone) unless block_given?

      opts[:timeout] ||= 50
      logger.info "starting get_updates loop"
      loop do
        messages = get_last_messages(opts.clone)
        messages.compact.each do |message|
          next unless message
          logger.info "message from #{message.chat.friendly_name}: #{message.text.inspect}"
          yield message
        end
      end
    end

    def send_message(out_message)
      logger.info "sending message: #{out_message.text.inspect} to #{out_message.chat_friendly_name}"
      @client
        .request(:sendMessage, payload: out_message)
        .and_then do |result|
          Message.new(result)
        end
        .value!
    end

    def send_photo(content)
      logger.info "sending photo to #{content.chat_friendly_name}"
      headers = content.new? ? {'Content-Type' => 'multipart/form-data'} : nil
      @client
        .request(:sendPhoto, payload: content, headers: headers)
        .and_then do |result|
          content.save(result)
        end
        .value!
    end

    def set_webhook(url, allowed_updates: %i(message))
      logger.info "setting webhook url to #{url}, allowed_updates: #{allowed_updates}"
      request = WebhookRequest.new(url: url, allowed_updates: allowed_updates)
      @client.request(:setWebhook, payload: request)
    end

    def remove_webhook
      set_webhook("")
    end

    attr_reader :logger
    private

    def get_last_updates(opts = {})
      opts[:offset] ||= @offset
      request = UpdatesRequest.new(opts)
      response = @client.request(:getUpdates, payload: request)
      if opts[:fail_silently] && !response.ok?
        logger.warn "error when getting updates. ignoring due to fail_silently."
        return []
      end
      updates = response.value!.compact.map{|raw_update| Update.new(raw_update) }
      @offset = updates.last.id + 1 if updates.any?
      updates
    end

    def get_last_messages(opts = {})
      get_last_updates(opts).map(&:message)
    end
  end
end
