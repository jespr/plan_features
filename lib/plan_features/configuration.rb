module PlanFeatures
  class Configuration
    attr_accessor :plans_file_path

    def initialize
      @plans_file_path = "config/pricing_plans.yml"
    end
  end
end
