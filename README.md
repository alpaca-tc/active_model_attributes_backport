# ActiveModelAttributes

Make `.attribute` in ActiveModel for `< Rails 5.2`.

**Deprecation Warning**

This is no longer needed on Rails5.2+.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_model_attributes_backport'
```

## Usage

Define `.attribute` to cast value.

```
class User
  include ActiveModelAttributes

  attribute :id, :integer
  attribute :no_cast
  attribute :user_id, :integer, default: -> { Current.user.id }
  attribute :locale, :string, default: 'ja'
end

user = User.new(id: '1')

user.id == 1
user.user_id == Current.user.id
user.locale == 'ja'
user.no_cast.nil?
```

```
# Lookup type from `ActiveModel::Type.lookup(type)` 
# ActiveModel::Type.registry.send(:registrations).map { |type| type.send(:name) }

:big_integer
:binary
:boolean
:date
:datetime
:decimal
:float
:integer
:string
:text
:time
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alpaca-tc/active_model_attributes.

run spec

```
bundle exec appraisal install
bundle exec appraisal 4.2-stable rspec
bundle exec appraisal 5.0-stable rspec
bundle exec appraisal 5.1-stable rspec
```
