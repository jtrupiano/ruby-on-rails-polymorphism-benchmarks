require 'active_record'  
require 'yaml'

task :default => :migrate  

# Dir.glob(File.join("models", "*.rb")) { |f| require f }
Dir.glob(File.join("lib", "*.rb")) { |f| require f }

namespace :db do

  desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"  
  task :migrate => :environment do 
    ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )  
  end  

  desc 'Create all the local databases defined in config/database.yml'
  task :create do
    ActiveRecord::Base.logger = Logger.new(File.open('log/database.log', 'a'))
    db = Db.new('db/dbs.yml')
    db.server_keys.each do |key|
      config = db.config(key)
      ActiveRecord::Base.establish_connection(config)
      create_database(config)
    end
  end
  
  desc 'Drops all the local databases defined in config/database.yml'
  task :drop do
    ActiveRecord::Base.logger = Logger.new(File.open('log/database.log', 'a'))
    db = Db.new('db/dbs.yml')
    db.server_keys.each do |key|
      config = db.config(key)
      ActiveRecord::Base.establish_connection(config)
      drop_database(config)
    end
  end
  
  desc "Loads in test data"
  task :load_data => :environment do
  #  require 'models/appserver'
  #  Appserver.create!(:ip => "208.78.99.125", :name => 'Tenant Portal')
  end
  
  desc "Drop, create, and rake a new database.  Also, load the data"
  task :reload => [:drop, :create, :migrate, :load_data]
  
end

task :environment do
  ActiveRecord::Base.establish_connection(db_config)  
  ActiveRecord::Base.logger = Logger.new(File.open('log/database.log', 'a'))  
end  

def db_config
  YAML::load(File.open('db/dbs.yml'))
end

# pulled from rails-2.0.2/lib/tasks/databases.rake
def create_database(config)
  begin
    ActiveRecord::Base.establish_connection(config)
    ActiveRecord::Base.connection
  rescue
    case config['adapter']
    when 'mysql'
      @charset   = ENV['CHARSET']   || 'utf8'
      @collation = ENV['COLLATION'] || 'utf8_general_ci'
      begin
        ActiveRecord::Base.establish_connection(config.merge({'database' => nil}))
        ActiveRecord::Base.connection.create_database(config['database'], {:charset => @charset, :collation => @collation})
        ActiveRecord::Base.establish_connection(config)
      rescue
        $stderr.puts "Couldn't create database for #{config.inspect}"
      end
    when 'postgresql'
      `createdb "#{config['database']}" -E utf8`
    when 'sqlite'
      `sqlite "#{config['database']}"`
    when 'sqlite3'
      `sqlite3 "#{config['database']}"`
    end
  else
    p "#{config['database']} already exists"
  end
end

def drop_database(config)
  case config['adapter']
  when 'mysql'
    ActiveRecord::Base.connection.drop_database config['database']
  when /^sqlite/
    FileUtils.rm('db/sqlite3.db')
  when 'postgresql'
    ActiveRecord::Base.establish_connection(config.merge('database' => 'postgres', 'schema_search_path' => 'public'))
    ActiveRecord::Base.connection.drop_database config['database']
  end
end

# Rake::Task['test:functionals'].invoke

task :run do
  require 'test/test_helper'
  require 'test/unit/int_assoc_test'
  require 'test/unit/int_assoc_ind_test'
  require 'test/unit/string_assoc_test'
  require 'test/unit/string_assoc_index_test'
end
