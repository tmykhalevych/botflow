require 'active_record'
require 'require_all'
require 'dotenv'
require 'hirb'

Hirb.enable :pager=>true
Hirb.enable :formatter=>false

Dotenv.load

require 'pry'
ENV['RACK_ENV'] = 'development' unless ENV['RACK_ENV']
require './lib/common/configurator.rb'
require_all 'db/adapter.rb'

desc "Run application"
task :default do
  redis_id = Process.fork do
    system('redis-server --port 6380')
  end
  system('ruby config.ru')
  Process.wait
  Process.abort(redis_id)
end

namespace :db do
  database = Database::Adapter.new(CONFIG.all)

  desc "Create the database"
  task :create do
    database.establish_connection
    database.create_new
    puts "Database created."
  end

  desc "Migrate the database"
  task :migrate do
    version = ARGV[1] || nil
    database.establish_connection
    ActiveRecord::MigrationContext.new(File.dirname(__FILE__) + CONFIG[:DB_MIGRATIONS_FOLDER]).migrate(version)
    Rake::Task["db:schema"].invoke
    puts "Database migrated."
    abort
  end

  desc "Roll back the database"
  task :rollback do
    database.establish_connection
    ActiveRecord::MigrationContext.new(File.dirname(__FILE__) + CONFIG[:DB_MIGRATIONS_FOLDER]).rollback
    Rake::Task["db:schema"].invoke
    puts "Database migrated."
  end

  desc "Drop the database"
  task :drop do
    database.establish_connection
    database.drop!
    puts "Database deleted."
  end

  desc "Reset the database"
  task :reset => [:drop, :create, :migrate]

  desc "Create a #{CONFIG[:DB_SCHEMA]} file that is portable against any DB supported by AR"
  task :schema do
    database.establish_connection
    require 'active_record/schema_dumper'
    File.open(CONFIG[:DB_SCHEMA], "w:utf-8") do |file|
      ActiveRecord::SchemaDumper.dump(Database.connection, file)
    end
  end

  desc "Show the list of database tables"
  task :list do
    database.establish_connection
    tables = ActiveRecord::Base.connection.tables - ["schema_migrations", "ar_internal_metadata"]
    puts "\ntables: #{tables.to_s}"
    puts ''
  end

  desc "Show propper table from database"
  task :table do
    tbl = ARGV[1]
    unless tbl then
      puts 'Specify table! Run \'rake db:list\' to show the list of tables.'
      exit
    end
    database.establish_connection
    puts ''
    puts "==> #{tbl}\n"
    puts Hirb::Helpers::AutoTable.render(ActiveRecord::Base.connection.execute("SELECT * FROM #{tbl};").to_a)
    puts ''
    abort
  end

  desc "Show all batabase tables"
  task :tables do
    database.establish_connection
    tables = ActiveRecord::Base.connection.tables - ["schema_migrations", "ar_internal_metadata"]
    puts ''
    tables.each do |tbl|
      puts "==> #{tbl}\n"
      puts Hirb::Helpers::AutoTable.render(ActiveRecord::Base.connection.execute("SELECT * FROM #{tbl};").to_a)
      puts ''
    end
  end
end

namespace :g do
  desc "Generate migration"
  task :migration do
    name = ARGV[1] || raise("Specify name: rake g:migration your_migration")
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    path = File.expand_path("..#{CONFIG[:DB_MIGRATIONS_FOLDER]}/#{timestamp}_#{name.downcase}.rb", __FILE__)
    migration_class = name.split("_").map(&:capitalize).join

    File.open(path, 'w') do |file|
      file.write <<-EOF
class #{migration_class} < ActiveRecord::Migration[5.2]
  def self.up
  end

  def self.down
  end
end
      EOF
    end

    puts "Migration #{path} created"
    abort # needed stop other tasks
  end
end

desc "Help output"
task :help do
  puts 'Here are the list of all supported Rake tasks - enjoy!'
  puts ''
  puts 'Application:'
  puts '  rake                                run application'
  puts ''
  puts 'Database operational helpers:'
  puts '  rake db:create                      create the db'
  puts '  rake db:migrate                     run migrations to the newest version'
  puts '  rake db:migrate <target_version>    run migrations to target version'
  puts '  rake db:rollback                    roll back previous migration'
  puts '  rake db:drop                        delete the db'
  puts '  rake db:reset                       combination of the upper three'
  puts '  rake db:schema                      creates a schema file of the current database'
  puts ''
  puts 'Database dumping helpers:'
  puts '  rake db:list                        show the list of database tables'
  puts '  rake db:table <table_name>          show propper table from database'
  puts '  rake db:tables                      show all batabase tables'
  puts ''
  puts 'Generators:'
  puts '  rake g:migration <migration_name>   generates a new migration file'
  puts ''
  puts 'Other:'
  puts '  rake help                           you\'ve already known about this one'
end
