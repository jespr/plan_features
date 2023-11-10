require_relative "lib/plan_features/version"

Gem::Specification.new do |spec|
  spec.name = "plan_features"
  spec.version = PlanFeatures::VERSION
  spec.authors = ["Jesper Christiansen"]
  spec.email = ["hi@jespr.com"]
  spec.summary = "Add Plan feature configuration to your Rails app"
  spec.description = "Define plans and their features in a YAML file and use them in your Rails app"
  spec.license = "MIT"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7"
end
