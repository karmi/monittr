$LOAD_PATH.unshift File.expand_path('../..', __FILE__)
require 'rubygems'
require 'test/unit'
require 'rack/test'
require 'shoulda'
require 'mocha'
require 'fakeweb'
require 'pathname'
require 'turn' unless ENV["TM_FILEPATH"]

ENV['RACK_ENV'] = 'test'

require 'lib/monittr'

class Test::Unit::TestCase

  def setup
    FakeWeb.register_uri(:get, 'http://admin:monit@localhost:2812/_status?format=xml', :body => fixture_file('status.xml'))
    FakeWeb.register_uri(:get, 'http://not-working/_status?format=xml', :body => '', :status => ['500'])
    FakeWeb.register_uri(:get, 'http://admin@timeout.net:2812/_status?format=xml', :exception => Timeout::Error)
    FakeWeb.allow_net_connect = false
  end

  def fixtures_path
    Pathname( File.expand_path( '../fixtures', __FILE__ ) )
  end

  def fixture_file(path)
    File.read File.expand_path( path, fixtures_path )
  end

end
