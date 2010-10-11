if ENV['MONGOHQ_URL']
  MongoMapper.config = {RAILS_ENV => {'uri' => ENV['MONGOHQ_URL']}}
  MongoMapper.connect(RAILS_ENV)
else
  # load db settings
  db_config = YAML::load(File.read(RAILS_ROOT + "/config/database.yml"))

  # connect to the db
  if db_config[Rails.env] && db_config[Rails.env]['adapter'] == 'mongodb'
    mongo = db_config[Rails.env]
    MongoMapper.connection = Mongo::Connection.new(mongo['hostname'], mongo['port'] || 27017, :logger => Rails.logger)
    MongoMapper.database = mongo['database']
  end
end

