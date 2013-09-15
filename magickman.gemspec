# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'magick_man/version'

Gem::Specification.new do |spec|
  spec.name          = "magickman"
  spec.version       = Magickman::VERSION
  spec.authors       = ["Michael Dykman"]
  spec.email         = ["mdykman@gmail.com"]
  spec.description   = %q{"A system to serve custom resized images on demand}
  spec.summary       = %q{A system to serve custom resized images on demand}
  spec.homepage      = ""
  spec.license       = "MIT"

#  spec.files         = `git ls-files`.split($/)
# spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
#  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.files         = Dir['lib/**/*'] + [ 
	 "app/controllers/magick_man/magickman_controller.rb",
	 "LICENSE.txt",
	 "README.md",
    ]
#  spec.files        = Dir["{lib,bin,spec}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.md", "CHANGELOG.md"]
  spec.add_dependency "rails", "~> 4.0"
   
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
