# Bnr::Webhooks

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bnr-webhooks'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bnr-webhooks

## Usage

### Initialization

Add the following code to an initializer in your Rails application (perhaps
in `config/initializers/bnr-webhooks.rb`):

```ruby
Bnr::Webhooks.configure do |config|
  config.api_key = 'your_api_key'
end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/bnr-webhooks/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
