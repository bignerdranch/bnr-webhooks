# Bnr::Webhooks

Provides a collection of tools for sending and receiving webhooks. This
includes:

* Controller for receiving incoming webhooks from other BNR services
* Methods for sending webhooks to subscribers
* Methods for signing and validating signatures in webhooks to confirm they
come from a trusted party

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

### Add a webhook endpoint

### Handle webhooks in the background

```ruby
class WebhookWorker < Bnr::Webhooks::Worker
  include Sidekiq::Worker

  def self.call(handler, event, source)
    perform_async(handler.to_s, event, source)
  end

  def perform(handler_name, event, source)
    handler = handler_name.constantize
    super(handler, event, source)
  end
end
```

### Bring your own subscribers

When sending a webhook you will need to provide a subscriber. Subscribers need to
respond to two methods:

* `api_key` - this is a shared secret between the system sending the webhook and
the subscriber
* `url` - the url the system the subscriber wants webhook requests sent to

## Contributing

1. Fork it ( https://github.com/[my-github-username]/bnr-webhooks/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
