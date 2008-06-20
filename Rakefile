require 'active_record'  
require 'yaml'

task :default => :run

# Dir.glob(File.join("models", "*.rb")) { |f| require f }
Dir.glob(File.join("lib", "*.rb")) { |f| require f }

namespace :db do

  desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"  
  task :migrate do 
    ActiveRecord::Base.logger = Logger.new(File.open('log/database.log', 'a'))
    db = Db.new('db/dbs.yml')
    db.server_keys.each do |key|
      config = db.config(key)
      ActiveRecord::Base.establish_connection(config)
      ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
    end
  end  

  desc 'Create all the local databases defined in config/database.yml'
  task :create do
    ActiveRecord::Base.logger = Logger.new(File.open('log/database.log', 'a'))
    db = Db.new('db/dbs.yml')
    db.server_keys.each do |key|
      config = db.config(key)
      #ActiveRecord::Base.establish_connection(config)
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
  
  
  desc "Drop, create, and rake a new database."
  task :reload => [:drop, :create, :migrate]
  
end

# pulled from rails-2.1.0/lib/tasks/databases.rake
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
        ActiveRecord::Base.establish_connection(config.merge('database' => nil))
        ActiveRecord::Base.connection.create_database(config['database'], :charset => (config['charset'] || @charset), :collation => (config['collation'] || @collation))
        ActiveRecord::Base.establish_connection(config)
      rescue
        $stderr.puts "Couldn't create database for #{config.inspect}, charset: #{config['charset'] || @charset}, collation: #{config['collation'] || @collation} (if you set the charset manually, make sure you have a matching collation)"
      end
    when 'postgresql'
      @encoding = config[:encoding] || ENV['CHARSET'] || 'utf8'
      begin
        ActiveRecord::Base.establish_connection(config.merge('database' => 'postgres', 'schema_search_path' => 'public'))
        ActiveRecord::Base.connection.create_database(config['database'], config.merge('encoding' => @encoding))
        ActiveRecord::Base.establish_connection(config)
      rescue
        $stderr.puts $!, *($!.backtrace)
        $stderr.puts "Couldn't create database for #{config.inspect}"
      end
    when 'sqlite'
      `sqlite "#{config['database']}"`
    when 'sqlite3'
      `sqlite3 "#{config['database']}"`
    end
  else
    $stderr.puts "#{config['database']} already exists"
  end
end

def drop_database(config)
  case config['adapter']
  when 'mysql'
    ActiveRecord::Base.connection.drop_database config['database']
  when /^sqlite/
    FileUtils.rm(config['database'])
  when 'postgresql'
    ActiveRecord::Base.establish_connection(config.merge('database' => 'postgres', 'schema_search_path' => 'public'))
    ActiveRecord::Base.connection.drop_database config['database']
  end
end

# Rake::Task['test:functionals'].invoke

task :run do
  require 'benchmark'
  require 'lib/test_helper'
  ['int_assoc', 'int_assoc_index', 'string_assoc', 'string_assoc_index'].each do |file| 
    require "lib/#{file}"
    require "benchmarks/#{file}_test"
    "#{file}_test".classify.constantize.run_benchmark
  end
end
