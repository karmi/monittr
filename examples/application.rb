$LOAD_PATH.unshift( File.expand_path('../../lib', __FILE__) )

require 'rubygems'
require 'monittr'
require 'sinatra'
require 'fakeweb'

require 'monittr/sinatra/monittr'

FakeWeb.register_uri(:get, 'http://localhost:2812/_status?format=xml', :body => File.read( File.expand_path('../../test/fixtures/status.xml', __FILE__)))

set :monit_urls,  ['http://localhost:2812/_status?format=xml', 'http://localhost:2812/_status?format=xml']
# set :template,   Proc.new { File.join(root, 'template.erb') }
# set :stylesheet, '/path/to/my/stylesheet'

get "/" do
  monit_html
end
