
ENV["RAILS_ENV"] = "test"
 
require 'rubygems'
require 'test/unit'

require 'active_record'
require 'active_record/fixtures'
require 'active_support'

#load shoulda as gem
require 'shoulda'

  
# load the code-to-be-tested
ActiveSupport::Dependencies.load_paths << File.dirname(__FILE__) + '/../lib/'
require File.dirname(__FILE__) + '/../init'
 
# establish the database connection
ActiveRecord::Base.configurations = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.establish_connection('soundex_find_test')
 
# capture the logging
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/test.log")
 
# load the schema ... silently
ActiveRecord::Migration.verbose = false
load(File.dirname(__FILE__) + "/schema.rb")
 
# load the ActiveRecord models
require File.dirname(__FILE__) + '/models/item.rb'
 
