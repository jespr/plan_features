# PlanFeatures

This is a gem for Rails to help you with which features are available for which plans in your paid app.

The idea is that you have a set of plans and each plan has a set of features. We want an easy way to list all available
plans and their features and we want the ability to inherit features from previous plans. Let's say you have a Free plan
with Feature A and Feature B. When you upgrade to the Paid plan which gives you Feature C and Feature D we still want the
checks for Feature A and Feature B to return true.

## Usage

Create a new file `config/plans.yml` or whatever and create a new initializer `config/initializers/plan_features.rb` with:

```
PlanFeatures.configure do |config|
  config.plans_file_path = Rails.root.join("config", "plans.yml")
end
```

## Plan configuration

Your `plans.yml` could look something like this:

```
free:
  name: "Free"
  features:
    feature_a:
      description: "Feature A"
    feature_b:
      description: "Feature B"

paid:
  name: "Paid"
  features:
    feature_c:
      description: "Feature C"
    feature_d:
      description: "Feature D"
  prices:
    monthly:
      product: STRIPE_ID
      amount: 500
```

This sets up two plans where the `free` plan has the features A and B and the paid plan has the features C and D.

## Feature inheritance from previous plans

We wouldn't want the paid user to lose access to the features from the Free plan. So let's go ahead and set the previous plan
on the `paid` plan definition to `free`:

```
  paid:
    name: "Paid"
    previous: free
  features:
    # features from the above example
```

Now it'll inherit the features defined in the Free plan.

We can check if a feature is available in our code:

```
plan = PricingFeatures::Pricing.find_by_identifier(:paid)
plan.has_feature?(:feature_c)
# => true
```

## Features with limits

Sometimes features aren't just boolean features. You might be able to create "posts", but on the free plan you can only create 2, but on the paid plan you can create let's say 50. We can define that like so:

```
free:
  name: "Free"
  features:
    posts:
      description: "2 posts"
      limit: 2

paid:
  name: "Paid"
  features:
    posts:
      description: "50 posts"
      limit: 50
```

In your code you can check for the limit of a feature with:

```
free_plan = PlanFeatures::Pricing.find_by_identifier(:free)
free_plan.limit_for(:posts)
# => 2

paid_plan = PlanFeatures::Pricing.find_by_identifier(:paid)
paid_plan.limit_for(:posts)
# => 50
```

### Metadata

You can add metadata to a plan by using the `metadata` key. Example:

```
paid:
  name: "Paid"
  metadata:
    popular: true
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem "plan_features"
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install plan_features
```

## Contributing

Contribution directions go here.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
