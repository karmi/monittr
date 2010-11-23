$LOAD_PATH.unshift File.expand_path('../..', __FILE__)
require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha'
require 'fakeweb'
require 'pathname'
require 'turn' unless ENV["TM_FILEPATH"]

require 'lib/monitr'

class Test::Unit::TestCase

  def setup
    FakeWeb.register_uri(:get, 'http://localhost:2812/_status?format=xml', :body => fixture_file('status.xml'))
    FakeWeb.allow_net_connect = false
  end

  def fixtures_path
    Pathname( File.expand_path( 'fixtures', File.dirname(__FILE__) ) )
  end

  def fixture_file(path)
    File.read File.expand_path( path, fixtures_path )
  end

end
