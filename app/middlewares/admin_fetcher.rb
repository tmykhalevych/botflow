require_relative './../models/admin.rb'

module Middleware
  class AdminFetcher
    def initialize(opts)
      @opts = opts
      @message = opts.fetch(:message)
    end

    def valid?
      true
    end

    def on_valid
      opts_with_admin
    end

    def on_invalid
      # do nothing
    end

    private
    attr_accessor :opts, :message

    def opts_with_admin
      admin = Administrator.find_by(telegram_id: message.from.id)
      admin = Administrator.create_from(message) unless admin
      opts.merge!({admin: admin})
      opts
    end
  end
end
