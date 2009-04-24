# Include hook code here
require File.dirname(__FILE__) + '/lib/soundex_find'
ActiveRecord::Base.send(:include, WGJ::SoundexFind)
