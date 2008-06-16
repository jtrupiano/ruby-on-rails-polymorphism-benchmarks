require 'yaml'

class Db
  def initialize(dbfile='db/dbs.yml')
    @dbconfig = YAML::load(File.open(dbfile))
  end

  def server_keys
    @dbconfig.collect { |key| key.first }
  end

  def config(key)
    @dbconfig[key]
  end
end
