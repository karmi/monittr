require 'test_helper'
require 'sinatra/base'
require 'monittr/sinatra/monittr'

class ExampleApp < Sinatra::Base
  register Sinatra::MonittrHTML

  get "/" do
    monittr.html
  end
end

class SinatraHelperTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    ExampleApp
  end

  context "Sinatra helper" do

    should "display monittr info" do
      get '/'

      assert last_response.ok?
      assert last_response.body.include?('myapplication.cz'), "Response body should contain: myapplication.cz"
      assert last_response.body.include?('thin_1'),           "Response body should contain: thin_1"
    end

  end

end
