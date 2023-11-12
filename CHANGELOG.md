### 0.4.0

- `limit_for` returns `0` instead of `nil` when called with a feature the plan doesn't have.

### 0.3.0

- Moved `popular` to `metadata` on a plan. Gives you the ability to add any type of metadata.

### 0.2.0

- Changed the feature limit key from `amount` to `limit`
- Removed `monthly_pricing_id` and `yearly_pricing_id`. Use `pricing_id(name: ...)` instead.

### 0.1.0

- Initial release
