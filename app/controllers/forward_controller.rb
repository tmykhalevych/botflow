require_relative "application_controller.rb"

module App
  class ForwardController < ApplicationController
    def initialize(opts)
      @opts = opts
      super(opts)
    end

    # ---- Here is the router for plain message ----
    def forward
      forwarding = try_to_forward(Administrator.state_str(admin.state))
      forwarding = default_forwarding unless forwarding
      forwarding.call
    end
    # ----------------------------------------------

    private

    def try_to_forward(state)
      route = state.split('_')
      return false if route.size < 2

      begin
        controller_class = "App::" + route.first.to_s.capitalize! + "Controller"
        controller = controller_class.constantize.new(@opts)
        action = route.second.to_sym
      rescue NameError
        return false
      end

      controller.method(action)
    end

    def default_forwarding
      ApplicationController.new(@opts).method(:start)
    end
  end
end
