require 'sinatra/base'
require 'erb'

module Sinatra
  module MonitrHTML

    module Helpers
      def monit
        Monitr::Server.fetch(settings.monit_url)
      end

      def monit_html
        ERB.new( File.read( settings.template ) ).result(binding)
      end
    end

    def self.registered(app)
      app.helpers MonitrHTML::Helpers

      app.set :monit_url, 'http://admin:monit@localhost:2812/_status?format=xml'
      app.set :template,  File.expand_path('../template.erb', __FILE__)
    end

  end

  register MonitrHTML
end
