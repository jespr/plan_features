require "plan_features/version"
require "plan_features/railtie"
require "plan_features/configuration"

module PlanFeatures
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
