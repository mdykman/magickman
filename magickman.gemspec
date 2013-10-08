# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'magickman/version'

Gem::Specification.new do |spec|
  spec.name          = "magickman"
  spec.version       = MagickMan::VERSION
  spec.authors       = ["Michael Dykman"]
  spec.email         = ["mdykman@gmail.com"]
  spec.description   = <<PIM
MagickMan is a Rails front-end manager for ImageMagick or any scriptable image processor.
The installation of ImageMagick varies between platforms, please 
consult the documentation for your platform.
PIM

  spec.summary       = %q{A system to serve custom processed images on demand}
  spec.homepage      = "https://github.com/mdykman/magickman"
  spec.license       = "MIT"

  spec.requirements = "requires ImageMagick.  See the documentation for your platform"
  
  spec.post_install_message = <<PIM
Welcome to MagickMan(ager)
 
To use in a rails application, run the generator:
   $ rails generate magick_man:install

  to create an initializer at config/initializers/magickman.rb

That file should be edited manually to provide your own custom formats.
PIM

#  spec.files         = `git ls-files`.split($/)
# spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
#  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_path = 'lib'
#  spec.files        = Dir["{lib,bin,spec}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.md", "CHANGELOG.md"]
  spec.files         = Dir['vendor/**/*'] + Dir['lib/**/*'] + ["LICENSE.txt","README.md"]

  spec.required_ruby_version = '~> 2.0'
#  spec.add_dependency "rails", '~> 4.0'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
