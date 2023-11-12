require_relative "feature"

module PlanFeatures
  class Pricing
    attr_accessor :name, :plan_identifier, :interval, :stripe_id, :features, :prices, :previous, :metadata

    include ActiveModel::Model

    def self.boosts
      @boosts ||= if File.exist?(Rails.root.join("config", "account_boosts.yml"))
        YAML.load_file(Rails.root.join("config", "account_boosts.yml"))
      end
    end

    def self.find_by_identifier(id)
      plan = Pricing.all_plans.find { |plan| plan.plan_identifier == id.to_s }
      raise "Plan not found" if plan.nil?

      plan
    end

    def self.find_by_pricing_id(id, interval: "monthly")
      Pricing.all_plans.find do |plan|
        !plan.free? && plan.prices && plan.prices[interval]["product"] == id
      end
    end

    def self.all_plans
      @all_plans ||= YAML.load_file(::PlanFeatures.configuration.plans_file_path).map do |plan, attributes|
        Pricing.new(
          plan_identifier: plan,
          name: attributes["name"],
          features: attributes["features"],
          prices: attributes["prices"],
          previous: attributes["previous"],
          metadata: attributes["metadata"]&.with_indifferent_access,
        )
      end
    end

    def self.free_plan
      Pricing.all_plans.find { |plan| plan.free? }
    end

    def current_and_previous_features
      features.merge(previous_features)
    end

    def has_feature?(feature, id: nil)
      return true if Pricing.boosts&.[](id)&.include?(feature.to_s)

      current_and_previous_features.find { |f| f[0] == feature.to_s }.present?
    end

    def previous_features
      previous_plan&.current_and_previous_features || {}
    end

    def previous_plan
      Pricing.all_plans.find do |plan|
        plan.plan_identifier == previous
      end
    end

    def limit_for(feature)
      features.dig(feature.to_s, "limit") || 0
    end

    def free?
      prices.nil?
    end

    def paid?
      prices&.any?
    end

    def pricing_id(name: :monthly)
      return nil if prices.nil?
      prices[name.to_s]["product"]
    end

    def price(name: :monthly)
      return nil if prices.nil?
      prices[name.to_s]["amount"] / 100
    end

    def yearly_price_monthly
      return nil if prices.nil?
      (prices["yearly"]["amount"].to_f / 100 / 12).round(2)
    end

    def display_features
      features.map do |identifier, attributes|
        PricingFeatures::Feature.new(
          identifier: identifier,
          description: attributes["description"],
          limit: attributes["limit"],
          hidden: attributes["hidden"]
        )
      end.compact.filter { |f| !f.hidden? }
    end
  end
end
