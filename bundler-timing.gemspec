
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bundler/timing/version"

Gem::Specification.new do |spec|
  spec.name          = "bundler-timing"
  spec.version       = Bundler::Timing::VERSION
  spec.authors       = ["Marvin Frick"]
  spec.email         = ["marvin.frick@shopify.com"]

  spec.summary       = "Collect and print per-gem install timings"
  spec.description   = "Ever wondered which gem takes the longest to install? This plugin will tell you!"
  spec.homepage      = "https://github.com/MrMarvin/bundler-timing"
  spec.license       = "MIT"


  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "bundler", ">= 2.5"
  spec.add_development_dependency "rake", "~> 10.0"
end
