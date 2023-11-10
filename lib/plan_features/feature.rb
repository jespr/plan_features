module PricingFeatures
  class Feature
    include ActiveModel::Model

    attr_accessor :identifier, :description, :limit, :hidden

    alias_method :hidden?, :hidden
  end
end
