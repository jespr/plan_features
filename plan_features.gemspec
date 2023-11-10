require_relative "lib/plan_features/version"

Gem::Specification.new do |spec|
  spec.name        = "plan_features"
  spec.version     = PlanFeatures::VERSION
  spec.authors     = ["Jesper Christiansen"]
  spec.email       = ["hi@jespr.com"]
  spec.summary     = "Summary of PlanFeatures."
  spec.description = "Description of PlanFeatures."
  spec.license     = "MIT"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7"
end
