require 'dotenv'
require 'require_all'
require 'virtus'
require 'rack'
require 'excon'
require 'faraday'
require 'r18n-core'
require 'redis'
require_all 'db/adapter.rb'

# Setup CONFIG, load ENV variables and libs
Dotenv.load
ENV['RACK_ENV'] = 'development' unless ENV['RACK_ENV']
require_all 'lib/**/*.rb'

# Create Telegram Bot API and all dependencies
bot_api_logger = Logger.new(STDOUT)
unless CONFIG[:TELEGRAM_API_BOT_TOKEN]
  bot_api_logger.fatal "Please set up 'TELEGRAM_API_BOT_TOKEN' env. variable!"
  exit
end
bot_api_token = CONFIG[:TELEGRAM_API_BOT_TOKEN]
bot_api_client = Telegram::Client.new(token: bot_api_token, logger: bot_api_logger)
bot_api = Telegram::BotApi.new(client: bot_api_client, logger: bot_api_logger)

# Establish database connection
database_logger = Logger.new(STDOUT)
database = Database::Adapter.new(CONFIG.all, database_logger)
database.establish_connection

# Check whether connection was established
unless Database.connected? then
  bot_api_logger.fatal "Cannot connet to the database!"
  exit
end

# Establish cache storage connection
cache = Cache::Adapter.new(CONFIG.all)
cache_storage = cache.establish_connection

# Setup localization handler
R18n.default_places = File.dirname(__FILE__) + '/config/local/'
R18n.set('en') # Temporary

# Setup media storage type
require_all 'app/media'
if CONFIG[:STORAGE_TYPE] == 'local'
  media_factory = App::LocalStorageFactory.new(cache_storage)
elsif CONFIG[:STORAGE_TYPE] == 'remote'
  media_factory = App::RemoteStorageFactory.new(cache_storage)
else
  bot_api_logger.fatal "Please set up 'STORAGE_TYPE' env. variable! The value can be 'local' or 'remote'."
  exit
end

# Run bot application
if (CONFIG[:TELEGRAM_API_INTERACT_METHOD] == "pull") then
  bot_api.get_updates(fail_silently: true) do |message|
    Bot::Application.new(
      message: message, 
      bot_api: bot_api,
      media_factory: media_factory
    ).start
  end
elsif (CONFIG[:TELEGRAM_API_INTERACT_METHOD] == "push") then
  # TODO: Implement WebHook bot application
else
  bot_api_logger.fatal "Please set up 'TELEGRAM_API_INTERACT_METHOD' env. variable! The value can be 'push' or 'pull'."
  exit
end
