# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sass/globbing/version"

Gem::Specification.new do |s|
  s.name        = "sass-globbing"
  s.version     = Sass::Globbing::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Chris Eppstein"]
  s.email       = ["chris@eppsteins.net"]
  s.homepage    = "http://chriseppstein.github.com/"
  s.summary     = %q{Allows use of globs in Sass @import directives.}
  s.description = %q{Allows use of globs in Sass @import directives.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'sass', '>= 3.1'

end
