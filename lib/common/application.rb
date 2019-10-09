require_relative 'router.rb'

module Bot
  class Application
    def initialize(opts)
      @opts = opts
    end

    def start
      Lib::Router.new(@opts).call_action if hadle_all_middlewares
    end

    private

    def hadle_all_middlewares
      problems = false

      Middlewares.get.each do |middleware|
        mw = middleware.new(@opts)
        if mw.valid? then
          @opts = mw.on_valid
        else
          mw.on_invalid
          problems = true
        end
      end

      return !problems
    end
  end
end
