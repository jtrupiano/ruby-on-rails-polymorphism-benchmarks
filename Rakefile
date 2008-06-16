require 'active_record'  
require 'yaml'  

task :default => :migrate  

namespace :db do

  desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"  
  task :migrate => :environment do 
    ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )  
  end  
  
  desc "Create the database"
  task :create => :environment do
    create_database(db_config)
  end
  
  desc "Drops the database"
  task :drop => :environment do
    ActiveRecord::Base.connection.execute("DROP DATABASE #{db_config['database']};")
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
  YAML::load(File.open('db/dbs.yml'))[ENV['RAILS_ENV'] || 'mysql']
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

# Rake::Task['test:functionals'].invoke

task :run do
  require 'test/test_helper'
  require 'test/unit/int_assoc_test'
  require 'test/unit/int_assoc_ind_test'
  require 'test/unit/string_assoc_test'
  require 'test/unit/string_assoc_index_test'
end
