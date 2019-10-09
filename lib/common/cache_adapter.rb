module Cache
    class Adapter
        def initialize(config)
            @config = {
                host:  config.fetch(:REDIS_HOST), 
                port: config.fetch(:REDIS_PORT)
              }
            @config[:db] = config[:REDIS_DB] if config[:REDIS_DB]
            @config[:password] = config[:REDIS_PASSWORD] if config[:REDIS_PASSWORD]
        end

        def establish_connection
            Redis.new(@config)
        end
    end
end
