require "test_helper"

class PlanFeaturesTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert PlanFeatures::VERSION
  end

  setup do
    @plans = PlanFeatures::Pricing.all_plans
  end

  test "it returns the right plans and features" do
    first_plan = @plans.first
    assert_equal "Free", first_plan.name
    assert_equal "free", first_plan.plan_identifier

    # First plan has the right features
    assert first_plan.has_feature?("feature_a")
    assert first_plan.has_feature?("feature_b")
    refute first_plan.has_feature?("feature_c")
    assert 2, first_plan.features.length

    second_plan = @plans.second
    assert_equal "Simple", second_plan.name
    assert_equal "simple", second_plan.plan_identifier
    # Second plan has the right features (a and b is inherited from the Free plan)
    assert second_plan.has_feature?("feature_a")
    assert second_plan.has_feature?("feature_b")
    assert second_plan.has_feature?("feature_c")
    assert_equal 3, second_plan.features.length
    assert_equal 4, second_plan.previous_features.length

    third_plan = @plans.third
    assert_equal "Business", third_plan.name
    assert_equal "business", third_plan.plan_identifier
    # Third plan does not have any previous plans, so it only has one feature
    assert_equal 1, third_plan.features.length
    assert_equal 0, third_plan.previous_features.length
    assert third_plan.has_feature?("feature_d")
    refute third_plan.has_feature?("feature_a")
    refute third_plan.has_feature?("does_not_exist")
  end

  test "a plan with no prices is free?" do
    free_plan = @plans.first

    assert free_plan.free?
    refute free_plan.paid?
    refute free_plan.price
  end

  test "a plan with prices defined is paid?" do
    plan = PlanFeatures::Pricing.find_by_identifier(:paid)

    assert plan.paid?
    refute plan.free?

    assert_equal 5, plan.price(name: "monthly")
    assert_equal 5, plan.price(name: :monthly)

    assert_equal 50, plan.price(name: "yearly")
    assert_equal 50, plan.price(name: :yearly)

    assert_equal "ABC", plan.pricing_id(name: :monthly)
    assert_equal "DEF", plan.pricing_id(name: :yearly)
  end

  test "display_features does not return hidden features" do
    plan = @plans.first

    assert_equal 3, plan.display_features.length
  end

  test "check the limit of a feature" do
    first_plan = @plans.first
    assert_equal 10, first_plan.limit_for(:limit_feature)

    second_plan = @plans.second
    assert_equal 20, second_plan.limit_for(:limit_feature)
  end

  test "metadata" do
    plan = PlanFeatures::Pricing.find_by_identifier(:simple)
    assert plan.metadata[:popular]
  end

  test "limit_for if plan doesn't have feature" do
    plan = PlanFeatures::Pricing.find_by_identifier(:free)
    assert_equal 0, plan.limit_for(:paid_limit_feature)
  end
end
