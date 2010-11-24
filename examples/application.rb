$LOAD_PATH.unshift( File.expand_path('../../lib', __FILE__) )

require 'rubygems'
require 'monitr'
require 'sinatra'
require 'fakeweb'

require 'monitr/sinatra/monitr'

FakeWeb.register_uri(:get, 'http://localhost:2812/_status?format=xml', :body => File.read( File.expand_path('../../test/fixtures/status.xml', __FILE__)))

get "/" do
  monit_html
end
