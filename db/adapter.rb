require 'active_record'

module Database
  class Adapter
    def initialize(config, logger = nil)
      @db_config = {
        adapter:  config.fetch(:DB_ADAPTER), 
        database: config.fetch(:DB_DATABASE)
      }
      @db_config[:host] = config[:DB_HOST] if config[:DB_HOST]
      @db_config[:port] = config[:DB_PORT] if config[:DB_PORT]
      @db_config[:username] = config[:DB_USERNAME] if config[:DB_USERNAME]
      @db_config[:password] = config[:DB_PASSWORD] if config[:DB_PASSWORD]
      @db_config[:encoding] = config[:DB_ENCODING] if config[:DB_ENCODING]
      @logger = logger
    end

    def establish_connection
      ActiveRecord::Base.logger = @logger if @logger
      ActiveRecord::Base.establish_connection(@db_config)
    end

    def create_new
      ActiveRecord::Base.connection.create_database(@db_config[:database])
    end

    def drop!
      ActiveRecord::Base.connection.drop_database(@db_config[:database])
    end
  end

  def self.connection
    ActiveRecord::Base.connection
  end

  def self.connected?
    self.connection
    ActiveRecord::Base.connected?
  end
end
