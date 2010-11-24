# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'monittr/version'

Gem::Specification.new do |s|
  s.name        = "monittr"
  s.version     = Monittr::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Karel Minarik']
  s.email       = ['karmi@karmi.cz']
  s.summary     = "Interface for Monit XML status output"

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "bundler", "~> 1.0.0"
  s.add_dependency "rest-client"
  s.add_dependency "nokogiri"

  s.add_development_dependency "shoulda"
  s.add_development_dependency "turn"
  s.add_development_dependency "fakeweb"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").select{|f| f =~ /^bin/}
  s.require_path = 'lib'
end
