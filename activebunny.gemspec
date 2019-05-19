$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "active_bunny/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "activebunny"
  spec.version     = ActiveBunny::VERSION
  spec.authors     = ["Marcel Hoppe"]
  spec.email       = ["marcel.hoppe@mni.thm.de"]
  spec.homepage    = "http://TODO"
  spec.summary     = "An easy to use framework for RabbitMQ integration into Rails"
  spec.description = "An easy to use framework for RabbitMQ integration into Rails"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency("activesupport", ">= 5.0", "< 7")
  spec.add_dependency "bunny", "~> 2.14"

  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "rails", "~> 6.0.0.rc1"
end
