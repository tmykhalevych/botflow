require_relative '../../../telegram/media.rb'

module Lib
    class LocalPhoto < ::Telegram::PhotoBase
        def initialize(name, cache)
            @path = ONFIG[:STORAGE_PATH] + na