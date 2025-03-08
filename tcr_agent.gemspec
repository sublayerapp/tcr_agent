require_relative "lib/tcr_agent/version"

Gem::Specification.new do |spec|
  spec.name = "tcr_agent"
  spec.version = TcrAgent::VERSION
  spec.authors = [""]
  spec.email = [""]

  spec.summary = "TCR Agent - A Ruby gem for Test && Commit || Revert workflow"
  spec.description = "A Ruby gem that implements the Test && Commit || Revert (TCR) workflow with AI assistance"
  spec.homepage = "https://github.com/yourusername/tcr_agent"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob(%w[
    lib/**/*
    bin/*
    README.md
    LICENSE.txt
  ])
  spec.bindir = "bin"
  spec.executables = ["tcr_agent"]
  spec.require_paths = ["lib"]

  spec.add_dependency "sublayer", "~> 0.2.8"
  spec.add_development_dependency "securerandom", "~> 0.4.1"

  # Development dependencies
  spec.add_development_dependency "rspec", "~> 3.10"
end 
