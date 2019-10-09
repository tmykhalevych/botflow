# Application configuration specific for production environment

CONFIG.setup do |config|

  # Database configuration
  config.set :DB_DATABASE,         to: 'production'
  config.set :DB_USERNAME,         to: ENV['DB_USERNAME']
  config.set :DB_PASSWORD,         to: ENV['DB_PASSWORD']

  # Media storage configuration
  config.set :STORAGE_TYPE,        to: ENV['STORAGE_TYPE']

end
