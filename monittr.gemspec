# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'monittr/version'

Gem::Specification.new do |s|
  s.name          = "monittr"
  s.version       = Monittr::VERSION
  s.platform      = Gem::Platform::RUBY
  s.summary       = "A Ruby and web interface for Monit statistics"
  s.homepage      = "http://github.com/karmi/monittr"
  s.authors       = [ 'Karel Minarik' ]
  s.email         = 'karmi@karmi.cz'

  s.files         = %w( README.markdown Rakefile LICENSE )
  s.files        += Dir.glob("lib/**/*")
  s.files        += Dir.glob("test/**/*")
  s.files        += Dir.glob("examples/**/*")

  s.require_path  = 'lib'

  s.extra_rdoc_files  = [ "README.markdown", "LICENSE" ]
  s.rdoc_options      = [ "--charset=UTF-8" ]

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "bundler", "> 1"
  s.add_dependency "rest-client"
  s.add_dependency "nokogiri"
  s.add_dependency "sinatra"

  s.add_development_dependency "shoulda"
  s.add_development_dependency "turn"
  s.add_development_dependency "fakeweb"
  s.add_development_dependency "mocha"

  s.description = <<-DESC
    Monittr provides a Ruby interface for loading and displaying statistics
    from multiple Monit instances and helpers for Sinatra web applications.
  DESC
end
