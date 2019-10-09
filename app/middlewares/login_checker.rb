require_relative './../models/admin.rb'

module Middleware
  class LoginChecker
    def initialize(opts)
      @opts = opts
      @message = opts.fetch(:message)
      @bot_api = opts.fetch(:bot_api)
      @admin = opts.fetch(:admin)
    end

    def valid?
      if !!admin then
        if admin.logged_in then
          true
        else
          message.get_command_for(bot_api) == '/login' ||
          message.get_command_for(bot_api) == '/start' ||
          admin.state == Administrator.state(:admin_login)
        end
      else
        true
      end
    end

    def on_valid
      opts
    end

    def on_invalid
      message.reply do |reply|
        command = message.get_command_for(bot_api)
        reply.text = "#{message.from.first_name}, we want you to /login"
        reply.send_with(bot_api)
      end
    end

    private
    attr_accessor :admin, :opts, :message, :bot_api
  end
end
