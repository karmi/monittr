require 'sinatra/base'
require 'erb'

module Sinatra
  module MonittrHTML

    module Helpers

      def monittr
        @monittr ||= HTML.new(self)
      end

    end

    class HTML

      attr_reader :app

      def initialize(app)
        @app = app
      end

      def cluster
        Monittr::Cluster.new(app.settings.monit_urls)
      end

      def html
        ERB.new( File.read( app.settings.template ) ).result(binding)
      end

      def stylesheet
        app.settings.stylesheet ? File.read( app.settings.stylesheet ) : ''
      end

      def time_in_words(seconds)
        case seconds
        when 0..60
          "#{seconds        } seconds"
        when 60..3600
          "#{seconds/60     } minutes"
        when 3600..86400
          "#{seconds/3600   } hours"
        when 86400..604800
          "#{seconds/86400  } days"
        when 604800..2419200
          "#{seconds/604800 } weeks"
        else
          nil
        end
      end

    end

    def self.registered(app)
      app.helpers MonittrHTML::Helpers

      app.set :monit_urls, ['http://admin:monit@localhost:2812/_status?format=xml']
      app.set :template,   File.expand_path('../template.erb', __FILE__)
      app.set :stylesheet, File.expand_path('../style.css', __FILE__)
    end

  end

  register MonittrHTML
end
