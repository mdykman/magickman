# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'magickman/version'

Gem::Specification.new do |spec|
  spec.name          = "magickman"
  spec.version       = MagickMan::VERSION
  spec.authors       = ["Michael Dykman"]
  spec.email         = ["mdykman@gmail.com"]
  spec.description   = %q{A system to serve custom resized images on demand}
  spec.summary       = %q{A system to serve custom resized images on demand}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.requirements = "requires ImageMagick.  See the documentation for your platform"
  spec.post_install_message = <<PIM
Welcome to MagickMan(ager)
MagickMan is a Rails front-end manager for ImageMagick. 
To use in a rails application, run the generator:
   $ rails generate magick_man:install

this will create an initiizer which contains relevant configuration at
     config/initializers/magickman.rb
PIM

#  spec.files         = `git ls-files`.split($/)
# spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
#  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_path = 'lib'
#  spec.files        = Dir["{lib,bin,spec}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.md", "CHANGELOG.md"]
  spec.files         = Dir['lib/**/*'] + ["LICENSE.txt","README.md"]

  spec.required_ruby_version = '~> 2.0'
  spec.add_dependency "rails", '~> 4.0'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
