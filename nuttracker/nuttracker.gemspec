require_relative "lib/nuttracker/version"

Gem::Specification.new do |spec|
  spec.name        = "nuttracker"
  spec.version     = Nuttracker::VERSION
  spec.authors     = ["Pup Gray"]
  spec.email       = ["pupgray@outlook.com"]
  spec.homepage    = "https://walltaker.joi.how"
  spec.summary     = "The nuttracker engine for walltaker"
  spec.description = "Nuttracker allows walltaker users to log orgasms publically."

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/pawcorp/walltaker"
  spec.metadata["changelog_uri"] = "https://github.com/pawcorp/walltaker"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.2.2"
end
