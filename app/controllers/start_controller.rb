require_relative "application_controller.rb"

module App
  class StartController < ApplicationController
    def start
      send_text_response(t.start(message.from.first_name))
    end
  end
end
