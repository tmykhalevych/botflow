# Application configuration common for all environments

CONFIG.setup do |config|

  # Telegram API configuration
  config.set :TELEGRAM_API,                 to: ENV['TELEGRAM_API']
  config.set :TELEGRAM_API_INTERACT_METHOD, to: ENV['TELEGRAM_API_INTERACT_METHOD']
  config.set :TELEGRAM_API_BOT_TOKEN,       to: ENV['TELEGRAM_API_BOT_TOKEN']

  # Server configuration
  config.set :SERVER_PORT,                  to: ENV['SERVER_PORT'],                 default: 9003
  config.set :SERVER_HOST,                  to: ENV['SERVER_HOST'],                 default: 'localhost'

  # Database configuration
  config.set :DB_ADAPTER,                   to: 'postgresql'
  config.set :DB_ENCODING,                  to: 'utf-8'
  config.set :DB_HOST,                      to: ENV['DB_HOST'],                     default: 'localhost'
  config.set :DB_PORT,                      to: ENV['DB_PORT'],                     default: 5432
  config.set :DB_MIGRATIONS_FOLDER,         to: '/db/migrate'
  config.set :DB_SCHEMA,                    to: 'db/schema.rb'

  # Cache configuration
  config.set :REDIS_HOST,                   to: ENV['REDIS_HOST'],                  default: 'localhost'
  config.set :REDIS_PORT,                   to: ENV['REDIS_PORT'],                  default: 6380

  # Administator configuration
  config.set :ADMIN_PASSWORD,               to: ENV['ADMIN_PASSWORD'],              default: nil

  # Media storage configuration
  config.set :STORAGE_PATH,                 to: ENV['STORAGE_PATH'],                default: File.join(File.dirname(__FILE__), '../../storage/')

end
