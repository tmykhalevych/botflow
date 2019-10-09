module Routes
  @@routes = {}

  def self.set(command, opts)
    @@routes[command] = opts
  end

  def self.get
    @@routes
  end
end

def command(com, controller:, action: :start)
  Routes.set(com.to_s, {controller: controller, action: action})
end

module Middlewares
  @@middlewares = {}

  def self.add(mdwr, position)
    return unless mdwr
    if(position == 'undefined') then
      pos = 0
    else
      pos = position
    end
    @@middlewares.merge!({pos=>mdwr})
  end

  def self.get
    mwrs = []
    @@middlewares.keys.sort.each do |key|
      mwrs.push(@@middlewares[key])
    end
    mwrs
  end
end

def middleware(mdwr, as: 'undefined')
  Middlewares.add(mdwr, as)
end

require_all 'config/routes.rb'

module Lib
  class Router
    def initialize(opts)
      @opts = opts
      @command = opts.fetch(:message).get_command_for(opts.fetch(:bot_api))
      @controller = ::App::ApplicationController.new(opts)
      @action = :start
    end

    def call_action(opts = {})
      find_route!
      controller.method(action).call
    end

    private
    attr_accessor :command, :controller, :action, :opts

    def find_route!
      route = Routes.get[command.to_s]
      route = Routes.get['default'] unless route
      return unless route

      @controller = route.fetch(:controller).new(opts)
      @action = route.fetch(:action)
    end
  end
end
