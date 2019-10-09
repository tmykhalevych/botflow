# Application configuration specific for development environment

CONFIG.setup do |config|

  # Database configuration
  config.set :DB_DATABASE,         to: 'staging'
  config.set :DB_USERNAME,         to: ENV['DB_USERNAME'],         default: 'user'
  config.set :DB_PASSWORD,         to: ENV['DB_PASSWORD'],         default: 'password'

  # Media storage configuration
  config.set :STORAGE_TYPE,        to: ENV['STORAGE_TYPE'],        default: 'local'

end
