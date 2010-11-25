# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'monittr/version'

Gem::Specification.new do |s|
  s.name          = "monittr"
  s.version       = Monittr::VERSION
  s.platform      = Gem::Platform::RUBY
  s.summary       = "Web interface for Monit statistics"
  s.homepage      = "http://github.com/karmi/monittr"
  s.authors       = [ 'Karel Minarik' ]
  s.email         = 'karmi@karmi.cz'

  s.files         = %w( README.markdown Rakefile LICENSE )
  s.files        += Dir.glob("lib/**/*")
  s.files        += Dir.glob("test/**/*")

  s.require_path  = 'lib'

  s.extra_rdoc_files  = [ "README.markdown", "LICENSE" ]
  s.rdoc_options      = [ "--charset=UTF-8" ]

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "bundler", "~> 1.0.0"
  s.add_dependency "rest-client"
  s.add_dependency "nokogiri"
  s.add_dependency "sinatra"

  s.add_development_dependency "shoulda"
  s.add_development_dependency "turn"
  s.add_development_dependency "fakeweb"

  s.description = <<-DESC
    Monittr provides a Ruby interface for displaying Monit statistics
    in Sinatra based web applications.

    It loads information from the web server embedded in Monit and
    makes it accessible as Ruby objects.

    It also displays the information in HTML with the provided helpers.
  DESC
end
