module PricingFeatures
  class Feature
    include ActiveModel::Model

    attr_accessor :description, :amount, :hidden

    alias_method :hidden?, :hidden
  end
end
