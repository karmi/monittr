require 'sinatra/base'
require 'erb'

module Sinatra
  module MonitrHTML
    def monit
      ::Monitr::Monit.new
    end

    def monit_html
      ERB.new( File.read( File.expand_path('../template.erb', __FILE__) ) ).result(binding)
    end
  end

  helpers MonitrHTML
end
