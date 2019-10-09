module CONFIG
  @@configs = {}

  def self.setup
    yield self
  end

  def self.set(key, to:, default: nil)
    unless to 
      @@configs[key] = default
    else
      @@configs[key] = to
    end
  end

  def self.[](key)
    @@configs[key]
  end

  def self.show
    @@configs.clone
  end

  def self.all
    @@configs.clone
  end
end

require_all 'config/environments/common.rb'

if (ENV['RACK_ENV'] == 'development')
  require_all 'config/environments/development.rb'
elsif (ENV['RACK_ENV'] == 'test')
  require_all 'config/environments/test.rb'
elsif (ENV['RACK_ENV'] == 'production')
  require_all 'config/environments/production.rb'
end
