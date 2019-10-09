require_relative "api_response.rb"

module Telegram
  class Client
    def initialize(token:, logger:, proxy: nil)
      @token = token
      @logger = logger
      @proxy = proxy
      @connection = conn
    end

    def request(method, payload: {}, headers: nil)
      res = @connection.post do |req|
        req.url "/bot#{@token}/#{method}"
        req.body = payload.to_h
        req.headers = headers unless headers.nil?
      end
      ApiResponse.from_excon(res)
    end

    private

    attr_reader :token, :logger

    def conn
      Faraday.new(url: CONFIG[:TELEGRAM_API]) do |faraday|
        faraday.request :url_encoded
        faraday.request :multipart
        faraday.adapter :net_http
        faraday.proxy   @proxy
      end
    end

  end
end
